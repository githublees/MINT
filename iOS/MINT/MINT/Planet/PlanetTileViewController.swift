//
//  PlanetTileViewController.swift
//  MINT
//
//  Created by choymoon on 2022/03/31.
//

import UIKit
import Moya

class PlanetTileViewController: UIViewController {
    
    private let statusBarBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .main
        return view
    }()
    
    private let navContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .main
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_back"), for: .normal)
        button.setTitle("Back", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.4), for: .highlighted)
        button.contentMode = .scaleToFill
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 25)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        button.titleLabel?.font = .pretendard(.bold, size: 17, false)
        return button
    }()
    
    private let vcTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 18, false)
        label.textColor = .white
        label.text = "토지 구매"
        return label
    }()
    
    private let koreanTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.semiBold, size: 14)
        label.textColor = .white
        label.text = "행성 이름"
        return label
    }()
    
    private let planetTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .rubikOne(size: 28)
        label.textColor = .main
        return label
    }()
    
    private let planetMapView: PlanetMapView
    
    private let planetTileCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(PlanetTileCell.self, forCellWithReuseIdentifier: "PlanetTileCell")
        collectionView.register(PlanetHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "PlanetHeaderView")
        return collectionView
    }()
    
    private let planet: Planet
    private let planetTileInfos: [PlanetTile]
    private let planetNetworkService = MoyaProvider<PlanetNetworkService>()
    private let selectedTileId: String?
    
    private var tileSections = 0
    private var dividedTiles: [[PlanetTile]] = []
    private var tileHeaderStrings: [String] = []
    private var selectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    init(planet: Planet, planetTileInfos: [PlanetTile], planetMapView: PlanetMapView, with selectedTileId: String? = nil) {
        self.planet = planet
        self.planetTileInfos = planetTileInfos
        self.planetMapView = planetMapView
        self.selectedTileId = selectedTileId
        super.init(nibName: nil, bundle: nil)
        planetTitleLabel.text = planet.name.uppercased()
        divideTileSections()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        UserManager.shared.tileDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let selectedTileId = selectedTileId {
            self.tileSelected(with: selectedTileId)
            self.planetTileCollectionView.scrollToItem(at: selectedIndexPath, at: .bottom, animated: true)
        }
    }
    
    deinit {
        UserManager.shared.tileDelegate = nil
    }
}

extension PlanetTileViewController {
    
    private func configureViews() {
        self.view.backgroundColor = .background
        
        self.view.addSubview(statusBarBackgroundView)
        statusBarBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        
        self.view.addSubview(navContainerView)
        navContainerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        navContainerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(15)
            make.width.equalTo(90)
            make.height.equalTo(45)
        }
        backButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        navContainerView.addSubview(vcTitleLabel)
        vcTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.view.addSubview(koreanTitleLabel)
        koreanTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(navContainerView.snp.bottom).offset(20)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
        
        self.view.addSubview(planetTitleLabel)
        planetTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(koreanTitleLabel.snp.bottom)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
        
        self.view.addSubview(planetMapView)
        planetMapView.snp.makeConstraints { make in
            make.top.equalTo(planetTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(planetMapView.snp.width).multipliedBy(0.56)
        }
        
        self.view.addSubview(planetTileCollectionView)
        planetTileCollectionView.snp.makeConstraints { make in
            make.top.equalTo(planetMapView.snp.bottom).offset(10)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
        planetTileCollectionView.dataSource = self
        planetTileCollectionView.delegate = self
    }
}

extension PlanetTileViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width / 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let _ = collectionView.cellForItem(at: indexPath) as? PlanetTileCell else { return }
        
        self.planetMapView.selectTile(withId: dividedTiles[indexPath.section][indexPath.row].tileId)
    }
}

extension PlanetTileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tileSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dividedTiles[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanetTileCell", for: indexPath) as? PlanetTileCell else {
            return UICollectionViewCell()
        }
        cell.setTileInfo(info: dividedTiles[indexPath.section][indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                               withReuseIdentifier: "PlanetHeaderView",
                                                                               for: indexPath) as? PlanetHeaderView else {
            return UICollectionReusableView()
        }
        
        headerView.titleLabel.text = tileHeaderStrings[indexPath.section]
        
        return headerView
    }
}

extension PlanetTileViewController: PlanetTileCellDelegate {
    
    func tileSelected(with tileId: String) {
        self.planetMapView.selectTile(withId: tileId)
    }
    
    func openTileContractViewController(with tileInfo: PlanetTile) {
        let vc = ContractViewController(tileInfo: tileInfo, planetInfo: self.planet)
        self.present(vc, animated: true, completion: nil)
    }
}

extension PlanetTileViewController {
    
    private func divideTileSections() {
        var carr: [Character] = []
        
        for info in planetTileInfos {
            if !carr.contains(info.tileId.suffix(5)[0]) {
                carr.append(info.tileId.suffix(5)[0])
                tileHeaderStrings.append("Section-\(info.tileId.suffix(5)[0])")
            }
        }
        
        carr.sort()
        self.tileSections = carr.count
        
        dividedTiles = .init(repeating: [], count: carr.count)
        
        for (index, value) in carr.enumerated() {
            for info in planetTileInfos {
                if info.tileId.suffix(5)[0] == value {
                    dividedTiles[index].append(info)
                }
            }
        }
        
        if let selectedTile = self.selectedTileId {
            let row = ((Int(selectedTile.suffix(3)) ?? 1) - 1)
            let alphabet = String(selectedTile.suffix(5).prefix(1))
            
            switch alphabet {
            case "A":
                selectedIndexPath = IndexPath(item: row, section: 0)
            case "B":
                selectedIndexPath = IndexPath(item: row, section: 1)
            case "C":
                selectedIndexPath = IndexPath(item: row, section: 2)
            case "D":
                selectedIndexPath = IndexPath(item: row, section: 3)
            case "E":
                selectedIndexPath = IndexPath(item: row, section: 4)
            case "F":
                selectedIndexPath = IndexPath(item: row, section: 5)
            case "G":
                selectedIndexPath = IndexPath(item: row, section: 6)
            case "H":
                selectedIndexPath = IndexPath(item: row, section: 7)
            default:
                selectedIndexPath = IndexPath(item: 0, section: 0)
            }
        }
    }
    
    @objc func closeView() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PlanetTileViewController: FavoriteTileDelegate {
    
    func listUpdated(list: [FavoriteTile]) {
        self.planetTileCollectionView.reloadData()
    }
}
