//
//  UserManager.swift
//  MINT
//
//  Created by choymoon on 2022/04/05.
//

import Foundation

import BigInt
import Moya
import web3swift

class UserManager {
    
    private init() {
        password = ""
    }
    public static let shared: UserManager = UserManager()
    
    private let tileNetworkService = MoyaProvider<TileNetworkService>()
    
    // SmartContract
    private let web3Ropsten = Web3.InfuraRopstenWeb3()
    private var wallet: ContractWallet?
    public var walletId: String? {
        wallet?.address
    }
    private var password: String
    private var cart: [String: PlanetTile] = Dictionary()
    private var sendingContracts: [TransactionSendingResult] = []
    private var favoriteList: [FavoriteTile] = [] {
        didSet {
                self.tileDelegate?.listUpdated(list: self.favoriteList)
        }
    }
    private var planets: [Planet] = []
    
    public var walletDelegate: WalletImportDelegate?
    public var tileDelegate: FavoriteTileDelegate?
    
    public func getPlanets() -> [Planet] {
        return self.planets
    }
    
    public func setPlanets(_ planets: [Planet]) {
        self.planets = planets
    }
    
    public func getPlanet(with id: Int) -> Planet {
        for p in planets {
            if p.pid == id {
                return p
            }
        }
        return planets[0]
    }
    
    public func logout() {
        self.wallet = nil
        self.password = ""
        self.sendingContracts = []
        self.favoriteList = []
        walletDelegate?.walletDisconnected()
    }
}

// MARK: - Cart
extension UserManager {
    
    public func cartContains(info: PlanetTile) -> Bool {
        if cart[info.tileId] != nil {
            return true
        }
        return false
    }
    
    public func addToCart(info: PlanetTile) {
        cart[info.tileId] = info
    }
    
    public func removeFromCart(tileId: String) {
        cart.removeValue(forKey: tileId)
    }
    
    public func cartList() -> [PlanetTile] {
        var result: [PlanetTile] = []
        
        for key in cart.keys {
            result.append(cart[key]!)
        }
        
        return result
    }
}

// MARK: - Tile Favorite
extension UserManager {
    
    enum TileFavoriteResult {
        case needWalletId
        case success
        case failure(message: String)
        case error(with: Error)
    }
    
    public func registerFavoriteTile(tileId: String, completion: @escaping (TileFavoriteResult) -> ()) {
        guard let walletID = self.walletId else { completion(.needWalletId); return }
        
        tileNetworkService.request(.addFavorite(tileId: tileId, walletId: walletID)) { result in
            switch result {
            case .success(let response):
                do {
                    let basic = try JSONDecoder().decode(TileBasicResponse.self, from: response.data)
                    switch basic.statusCode {
                    case 201:
                        self.fetchFavoriteList()
                        completion(.success)
                    default:
                        completion(.failure(message: basic.message))
                    }
                } catch {
                    completion(.error(with: error))
                }
            case .failure(let error):
                completion(.error(with: error))
            }
        }
    }
    
    public func removeFavoriteTile(tileId: String, completion: @escaping (TileFavoriteResult) -> ()) {
        guard let walletID = self.walletId else { completion(.needWalletId); return }
        
        tileNetworkService.request(.removeFavorite(tileId: tileId, walletId: walletID)) { result in
            switch result {
            case .success(let response):
                do {
                    let basic = try JSONDecoder().decode(TileBasicResponse.self, from: response.data)
                    switch basic.statusCode {
                    case 200, 201:
                        self.fetchFavoriteList()
                        completion(.success)
                    default:
                        completion(.failure(message: basic.message))
                    }
                } catch {
                    completion(.error(with: error))
                }
            case .failure(let err):
                completion(.error(with: err))
            }
        }
    }
    
    public func fetchFavoriteList() {
        guard let walletID = self.walletId else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.tileNetworkService.request(.favoriteList(walletId: walletID)) { result in
                switch result {
                case .success(let response):
                    do {
                        let list = try JSONDecoder().decode([FavoriteTile].self, from: response.data)
                        self.favoriteList = list
                    } catch {
                        print(error)
                    }
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    public func listContains(tileId: String) -> Bool {
        return favoriteList.contains { favTile in
            favTile.tileId == tileId
        }
    }
}

// MARK: - SmartContract
extension UserManager {
    
    enum ContractResult {
        case success(hash: String)
        case failure(message: String)
        case error(with: Error)
    }
    
    public func walletInfo() -> ContractWallet? {
        return self.wallet
    }
    
    public func importUserWallet(privateKey: String, password: String, walletName: String = "New Wallet", completion: @escaping (Bool) -> ()) {
        self.password = password
        let formattedKey = privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let dataKey = Data.fromHex(formattedKey) else {
            completion(false)
            return
        }
        guard let keystore = try? EthereumKeystoreV3(privateKey: dataKey, password: password) else {
            completion(false)
            return
        }
        let name = walletName
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
        let address = keystore.addresses!.first!.address
        self.wallet = ContractWallet(address: address, data: keyData, name: name, isHD: false)
        
        let keystoreManager = KeystoreManager([keystore])
        self.web3Ropsten.addKeystoreManager(keystoreManager)
        
        self.walletDelegate?.walletConnected()
        completion(true)
    }
    
    public func getWalletBalnce(completion: @escaping (String) -> ()) {
        OperationQueue().addOperation {
            guard let address = self.wallet?.address else {
                completion("error")
                return
            }
            guard let walletAddress = EthereumAddress(address) else {
                completion("error")
                return
            }
            guard let balanceResult = try? self.web3Ropsten.eth.getBalance(address: walletAddress) else {
                completion("error")
                return
            }
            guard let balanceString = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 5) else {
                completion("error")
                return
            }
            completion(balanceString)
        }
    }
    
    public func buyTile(galaxy: String, planet: String,
                        tile: String, price: Double,
                        completion: @escaping (ContractResult) -> ()) {
        
        guard let walletID = self.walletId else {
            completion(.failure(message: "No Wallet ID"))
            return
        }
        
        let contract = "0x58A1E6FFf914C23011A3fF99CdE84E7DaD3D82AC"
        let value = "\(price)"
        
        guard let walletAddress = EthereumAddress(walletID) else {
            completion(.failure(message: "No Wallet Ethereum Address"))
            return
        }
        let contractABI = Abi.abi.rawValue
        guard let contractAddress = EthereumAddress(contract) else {
            completion(.failure(message: "No Contract Ethereum Address"))
            return
        }
        let abiVersion = 2
        let weiPrice = BigInt(price * 1000000000000000000)
        let parameters = [galaxy, planet, tile, weiPrice] as [AnyObject]
        
        guard let contract = web3Ropsten.contract(contractABI, at: contractAddress, abiVersion: abiVersion) else {
            completion(.failure(message: "No Contract"))
            return
        }
        let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
        var options = TransactionOptions.defaultOptions
        options.value = amount
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        
        guard let transaction = contract.write("createAndBuy", parameters: parameters, extraData: Data(), transactionOptions: options) else {
            completion(.failure(message: "Contract write failed"))
            return
        }
        
        do {
            let call = try transaction.send(password: password, transactionOptions: nil)
            sendingContracts.append(call)
            completion(.success(hash: call.hash))
        } catch {
            completion(.error(with: error))
        }
    }
    
    public func getMyBoughtTiles(completion: @escaping (ContractResult) -> ()) {
        guard let walletID = self.walletId else {
            completion(.failure(message: "No Wallet ID"))
            return
        }
        
        let contract = "0x58A1E6FFf914C23011A3fF99CdE84E7DaD3D82AC"
        
        guard let walletAddress = EthereumAddress(walletID) else {
            completion(.failure(message: "No Wallet Ethereum Address"))
            return
        }
        let contractABI = Abi.abi.rawValue
        guard let contractAddress = EthereumAddress(contract) else {
            completion(.failure(message: "No Contract Ethereum Address"))
            return
        }
        let abiVersion = 2
        
        guard let contract = web3Ropsten.contract(contractABI, at: contractAddress, abiVersion: abiVersion) else {
            completion(.failure(message: "No Contract"))
            return
        }
        var options = TransactionOptions.defaultOptions
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        
        guard let transaction = contract.read("getMyTile", parameters: [], extraData: Data(), transactionOptions: options) else {
            completion(.failure(message: "Contract write failed"))
            return
        }
        
        do {
            let call = try transaction.call()
            print(call)
        } catch {
            completion(.error(with: error))
        }
    }
}

protocol WalletImportDelegate {
    
    func walletConnected()
    func walletDisconnected()
}

protocol FavoriteTileDelegate {
    
    func listUpdated(list: [FavoriteTile])
}
