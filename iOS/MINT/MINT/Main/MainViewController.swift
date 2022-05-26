//
//  MainViewController.swift
//  MINT
//
//  Created by choymoon on 2022/03/22.
//

import UIKit

import Lottie
import SnapKit
import Moya

// MARK: - Variables
class MainViewController: UIViewController {

    // Views
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
    
    private let navTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "MINT"
        label.textColor = .white
        label.font = .rubikOne(size: 26, false)
        return label
    }()
    
    private let planetCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(MainPlanetCell.self, forCellWithReuseIdentifier: "PlanetCell")
        collectionView.backgroundColor = .clear
        let imageView = UIImageView(image: UIImage(named: "bg_stars"))
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.5
        collectionView.backgroundView = imageView
        return collectionView
    }()
    
    private let questionButton: UIButton = {
        let button = UIButton()
        button.tintColor = .lightMain
        button.setImage(UIImage(named: "ic_question"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let page = UIPageControl()
        page.pageIndicatorTintColor = .darkGray
        page.currentPageIndicatorTintColor = .main
        page.isUserInteractionEnabled = false
        return page
    }()
    
    // Variables
    private let planetNetworkService = MoyaProvider<PlanetNetworkService>()
    
    private var planetInfos: [Planet] = [] {
        didSet {
            self.planetCollectionView.reloadData()
            if !self.planetInfos.isEmpty {
                self.planetCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .left, animated: false)
            }
            self.pageControl.currentPage = 0
        }
    }
}

// MARK: - Life Cycles
extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        configureViews()
        getPlanetDetailInfoList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.planetCollectionView.reloadData()
    }
}

// MARK: - View Configure
extension MainViewController {
    
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
        
        navContainerView.addSubview(navTitleLabel)
        
        navTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.view.addSubview(planetCollectionView)
        planetCollectionView.dataSource = self
        planetCollectionView.delegate = self
        
        planetCollectionView.snp.makeConstraints { make in
            make.top.equalTo(navContainerView.snp.bottom)
            make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.view.addSubview(questionButton)
        questionButton.snp.makeConstraints { make in
            make.top.equalTo(navContainerView.snp.bottom).offset(12)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-12)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        questionButton.addTarget(self, action: #selector(presentDescription), for: .touchUpInside)
        
        self.view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
    }
}

// MARK: - CollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planetInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanetCell", for: indexPath) as? MainPlanetCell else {
            return UICollectionViewCell()
        }
        
        cell.setCellInfo(planet: planetInfos[indexPath.row])
        return cell
    }
}

// MARK: - CollectionViewDelegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let planetCell = cell as? MainPlanetCell else { return }
        planetCell.startAnimation(animation: planetInfos[indexPath.row].name)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let planetCell = cell as? MainPlanetCell else { return }
        planetCell.stopAnimaiont()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presentPlanetDetailInfoVC(with: planetInfos[indexPath.row])
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageFloat = (scrollView.contentOffset.x / scrollView.frame.size.width)
        let pageInt = Int(round(pageFloat))
        
        switch pageInt {
        case 0:
            planetCollectionView.scrollToItem(at: [0, planetInfos.count - 2], at: .left, animated: false)
            self.pageControl.currentPage = planetInfos.count - 3
        case planetInfos.count - 1:
            planetCollectionView.scrollToItem(at: [0, 1], at: .left, animated: false)
            self.pageControl.currentPage = 0
        default:
            self.pageControl.currentPage = pageInt - 1
        }
    }
    
    @objc private func presentDescription() {
        let vc = DescriptionViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - Functions
extension MainViewController {
    
    private func presentPlanetDetailInfoVC(with planet: Planet) {
        let vc = PlanetDetailInfoViewController(planet: planet)
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        present(vc, animated: false) {
            self.viewWillDisappear(true)
        }
    }
    
    private func getPlanetDetailInfoList() {
        
        planetNetworkService.request(.planets) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let result = try JSONDecoder().decode(PlanetResponse.self, from: response.data)
                    
                    var infos = result.planet
                    
                    if !infos.isEmpty {
                        infos.append(result.planet.first!)
                        infos.insert(result.planet.last!, at: 0)
                    }
                    UserManager.shared.setPlanets(infos)
                    self?.pageControl.numberOfPages = result.planet.count
                    self?.planetInfos = infos
                } catch (let err) {
                    print(err)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MainViewController: PlanetViewDelegate {
    
    func showPlanetTileViewController(planet: Planet) {
        getTileInfos(planet: planet) { result in
            switch result {
            case .success(let tileInfos):
                let mapView = self.getPlanetMapView(planet: planet, with: tileInfos)
                mapView.backgroundImage = UIImage(named: "bg_\(planet.name.lowercased())")
                let vc = PlanetTileViewController(planet: planet, planetTileInfos: tileInfos, planetMapView: mapView)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case .failure:
                break
            }
        }
    }
    
    private func getTileInfos(planet: Planet, completion: @escaping (Result<[PlanetTile], Error>) -> Void ) {
        planetNetworkService.request(.planetTiles(planetId: planet.pid)) { result in
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
