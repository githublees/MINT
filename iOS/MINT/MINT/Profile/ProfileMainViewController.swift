//
//  ProfileMainViewController.swift
//  MINT
//
//  Created by choymoon on 2022/03/22.
//

import UIKit
import Moya

class ProfileMainViewController: UIViewController {
        
    private let navTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.textColor = .main
        label.font = .rubikOne(size: 32)
        return label
    }()
    
    private let noWalletContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        return view
    }()
    
    private let noWalletTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 지갑이 등록되어있지 않아요..   :("
        label.font = .pretendard(.black, size: 16)
        label.textColor = .white
        return label
    }()
    
    private let registerWalletButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = .main
        button.setTitle("지갑 연결하기", for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.setImage(UIImage(named: "ic_link"), for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .pretendard(.black, size: 18)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: -5)
        return button
    }()
    
    private let walletContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        return view
    }()
    
    private let walletView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBackground
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 14)
        label.textColor = .lightMain
        label.text = "지갑 정보"
        return label
    }()
    
    private let walletNameLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 24)
        label.textColor = .white
        return label
    }()
    
    private let walletAddressLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.medium, size: 11.5)
        label.textColor = .lightGray
        return label
    }()
    
    private let walletBalanceLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.semiBold, size: 18)
        label.textColor = .white
        label.text = "- ETH"
        return label
    }()
    
    private let favListLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 20)
        label.text = "찜 목록"
        label.textColor = .white
        return label
    }()
    
    private let noFavListLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 22)
        label.text = "찜 목록이 비어있어요 :)"
        label.textColor = .white
        return label
    }()
    
    private let noFavListView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBackground
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let favListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(FavTileCell.self, forCellWithReuseIdentifier: "FavTileCell")
        return collectionView
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Disconnect", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.layer.cornerRadius = 12
        button.backgroundColor = .lightestMain
        button.titleLabel?.font = .pretendard(.black, size: 16)
        return button
    }()
    
    private let userManager = UserManager.shared
    private let planetNetworkService = MoyaProvider<PlanetNetworkService>()
    private var favTileList: [FavoriteTile] = []
    private var onDelete: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        userManager.walletDelegate = self
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userManager.tileDelegate = self
        setWalletViewStatus()
    }
}

extension ProfileMainViewController {
    
    private func configureViews() {
        self.view.backgroundColor = .background
        
        self.view.addSubview(navTitleLabel)
        navTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
        }
        
        self.view.addSubview(noWalletContainerView)
        noWalletContainerView.snp.makeConstraints { make in
            make.top.equalTo(navTitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
        
        noWalletContainerView.addSubview(noWalletTitleLabel)
        noWalletTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview()
        }
        
        noWalletContainerView.addSubview(registerWalletButton)
        registerWalletButton.snp.makeConstraints { make in
            make.top.equalTo(noWalletTitleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        registerWalletButton.addTarget(self, action: #selector(presentWalletImportView), for: .touchUpInside)
        
        self.view.addSubview(walletContainerView)
        walletContainerView.snp.makeConstraints { make in
            make.top.equalTo(navTitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
        
        walletContainerView.addSubview(walletView)
        walletView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        walletView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(14)
        }
        
        walletView.addSubview(walletNameLabel)
        walletNameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(14)
        }
        
        walletView.addSubview(walletAddressLabel)
        walletAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(walletNameLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(14)
        }
        
        walletView.addSubview(walletBalanceLabel)
        walletBalanceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-14)
        }
        
        let ether = UIImageView(image: UIImage(named: "ic_ethereum"))
        ether.tintColor = .white
        walletView.addSubview(ether)
        ether.snp.makeConstraints { make in
            make.right.equalTo(walletBalanceLabel.snp.left).offset(-2)
            make.centerY.equalTo(walletBalanceLabel)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        walletView.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(walletAddressLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
            make.bottom.equalToSuperview().offset(-14)
        }
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        walletContainerView.addSubview(favListLabel)
        favListLabel.snp.makeConstraints { make in
            make.top.equalTo(walletView.snp.bottom).offset(20)
            make.left.equalToSuperview()
        }
        
        walletContainerView.addSubview(noFavListView)
        noFavListView.snp.makeConstraints { make in
            make.top.equalTo(favListLabel.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        noFavListView.addSubview(noFavListLabel)
        noFavListLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        walletContainerView.addSubview(favListCollectionView)
        favListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(favListLabel.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        favListCollectionView.dataSource = self
        favListCollectionView.delegate = self
    }
    
    private func setWalletViewStatus() {
        if let walletInfo = userManager.walletInfo() {
            noWalletContainerView.alpha = 0
            noWalletContainerView.isUserInteractionEnabled = false
            walletContainerView.alpha = 1
            walletContainerView.isUserInteractionEnabled = true
            walletNameLabel.text = walletInfo.name
            walletAddressLabel.text = walletInfo.address
            getBalance()
            userManager.fetchFavoriteList()
        } else {
            noWalletContainerView.alpha = 1
            noWalletContainerView.isUserInteractionEnabled = true
            walletContainerView.alpha = 0
            walletContainerView.isUserInteractionEnabled = false
        }
    }
    
    private func getBalance() {
        userManager.getWalletBalnce { result in
            DispatchQueue.main.sync {
                self.walletBalanceLabel.text = result + " ETH"
            }
        }
    }
}

extension ProfileMainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FavTileCell else { return }
        guard let tileInfo = cell.tileInfo else { return }
        showPlanetTileViewController(planetId: tileInfo.planetId, tileId: tileInfo.tileId)
    }
}

extension ProfileMainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favTileList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavTileCell", for: indexPath) as? FavTileCell else {
            return UICollectionViewCell()
        }
        
        cell.setCellInfo(tileId: favTileList[indexPath.row].tileId, indexPath: indexPath)
        cell.delegate = self
        
        return cell
    }
}

extension ProfileMainViewController {
    
    @objc private func presentWalletImportView() {
        let vc = ProfileWalletImportViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
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
    
    @objc private func logout() {
        userManager.logout()
    }
}

extension ProfileMainViewController: WalletImportDelegate {
    
    func walletConnected() {
        self.setWalletViewStatus()
    }
    
    func walletDisconnected() {
        self.setWalletViewStatus()
        ToastAlert().show(title: "연결 해제 완료 :)", labelColor: .main, duration: 0.5, isTop: true)
    }
}

extension ProfileMainViewController: FavoriteTileDelegate {
    
    func listUpdated(list: [FavoriteTile]) {
        self.favTileList = list
        if list.isEmpty {
            noFavListView.alpha = 1
            noFavListView.isUserInteractionEnabled = true
            favListCollectionView.alpha = 0
            favListCollectionView.isUserInteractionEnabled = false
        } else {
            noFavListView.alpha = 0
            noFavListView.isUserInteractionEnabled = false
            favListCollectionView.alpha = 1
            favListCollectionView.isUserInteractionEnabled = true
            if !onDelete {
                favListCollectionView.reloadData()
            } else {
                onDelete = false
            }
        }
    }
}

extension ProfileMainViewController: FavTileCellDelegate {
    
    func setOnDelete(_ value: Bool) {
        self.onDelete = value
    }
    
    func deleteCell(at indexPath: IndexPath) {
        self.favListCollectionView.performBatchUpdates {
            self.favTileList.remove(at: indexPath.row)
            self.favListCollectionView.deleteItems(at: [indexPath])
        } completion: { finished in
            if finished {
                self.userManager.fetchFavoriteList()
                self.onDelete = false
            }
        }
    }
}
