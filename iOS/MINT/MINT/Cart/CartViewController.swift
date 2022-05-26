//
//  CartViewController.swift
//  MINT
//
//  Created by choymoon on 2022/03/31.
//

import UIKit

import Moya

class CartViewController: UIViewController {
    
    private let navTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cart"
        label.textColor = .main
        label.font = .rubikOne(size: 32)
        return label
    }()

    private let cartCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(CartTileInfoCell.self, forCellWithReuseIdentifier: "CartCell")
        return collectionView
    }()
    
    private let noCartView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBackground
        view.layer.cornerRadius = 12
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let noCartItemLabel: UILabel = {
        let label = UILabel()
        label.text = "장바구니가 비어있어요 :)"
        label.font = .pretendard(.black, size: 18)
        label.textColor = .white
        return label
    }()
    
    private let userManager = UserManager.shared
    private let planetNetworkService = MoyaProvider<PlanetNetworkService>()

    private var cartList: [PlanetTile] = [] {
        didSet { self.cartCollectionView.reloadData() }
    }
}

extension CartViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCartStatus()
        userManager.tileDelegate = self
    }
}

extension CartViewController {
    
    private func configureViews() {
        self.view.backgroundColor = .background
        
        self.view.addSubview(navTitleLabel)
        navTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
        }
        
        self.view.addSubview(cartCollectionView)
        cartCollectionView.snp.makeConstraints { make in
            make.top.equalTo(navTitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
        cartCollectionView.delegate = self
        cartCollectionView.dataSource = self
        
        self.view.addSubview(noCartView)
        noCartView.snp.makeConstraints { make in
            make.top.equalTo(navTitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
        
        noCartView.addSubview(noCartItemLabel)
        noCartItemLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setCartStatus() {
        self.cartList = userManager.cartList()
        
        if cartList.isEmpty {
            noCartView.alpha = 1
            cartCollectionView.alpha = 0
        } else {
            noCartView.alpha = 0
            cartCollectionView.alpha = 1
        }
    }
    
    func showPlanetTileViewController(planetId: Int, tileId: String) {
        getTileInfos(planetId: planetId) { result in
            switch result {
            case .success(let tileInfos):
                let planet = self.userManager.getPlanet(with: planetId)
                let mapView = self.getPlanetMapView(planet: planet, with: tileInfos)
                mapView.backgroundImage = UIImage(named: "bg_\(planet.name.lowercased())")
                let vc = PlanetTileViewController(planet: planet, planetTileInfos: tileInfos, planetMapView: mapView, with: tileId)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case .failure:
                break
            }
        }
    }
    
    private func getTileInfos(planetId: Int, completion: @escaping (Result<[PlanetTile], Error>) -> Void ) {
        planetNetworkService.request(.planetTiles(planetId: planetId)) { result in
            switch result {
            case .success(let response):
                do {
                    let result = try JSONDecoder().decode(PlanetTileResponse.self, from: response.data)
                    
                    completion(.success(result.tiles))
                } catch (let err) {
                    print(err)
                    completion(.failure(err))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    private func getPlanetMapView(planet: Planet, with tileInfos: [PlanetTile]) -> PlanetMapView {
        switch planet.name.uppercased() {
        case "TEEGARDEN_B":
            return TeegardenBMapView(tileInfos: tileInfos)
        case "KEPLER_22B":
            return Kepler22BMapView(tileInfos: tileInfos)
        case "KEPLER_1649C":
            return Kepler1649CMapView(tileInfos: tileInfos)
        case "PROXIMA_B":
            return ProximaBMapView(tileInfos: tileInfos)
        case "ROSS_128B":
            return Ross128BMapView(tileInfos: tileInfos)
        default:
            return PlanetMapView(tileInfos: [])
        }
    }
}

extension CartViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartCell", for: indexPath) as? CartTileInfoCell else {
            return UICollectionViewCell()
        }
        
        cell.setCellInfo(tileInfo: cartList[indexPath.row], indexPath: indexPath)
        cell.delegate = self
        
        return cell
    }
}

extension CartViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CartTileInfoCell else { return }
        guard let tileInfo = cell.tileInfo else { return }
        showPlanetTileViewController(planetId: tileInfo.planetId, tileId: tileInfo.tileId)
    }
}

extension CartViewController: CartTileCellDelegate {
    
    func deleteCell(at indexPath: IndexPath) {
        self.cartCollectionView.performBatchUpdates {
            self.userManager.removeFromCart(tileId: self.cartList[indexPath.row].tileId)
            self.cartList.remove(at: indexPath.row)
            self.cartCollectionView.deleteItems(at: [indexPath])
        } completion: { finished in
            if finished {
                self.setCartStatus()
            }
        }
    }
}

extension CartViewController: FavoriteTileDelegate {
    
    func listUpdated(list: [FavoriteTile]) {
        self.cartCollectionView.reloadData()
    }
}
