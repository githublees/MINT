//
//  MainViewController.swift
//  MINT
//
//  Created by choymoon on 2022/03/22.
//

import UIKit

import Lottie
import SnapKit

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
        label.font = .rubikOne(size: 26)
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
        return collectionView
    }()
    
    private let questionButton: UIButton = {
        let button = UIButton()
        button.tintColor = .lightMain
        button.setImage(UIImage(named: "ic_question"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        return button
    }()
    
    // Variables
    private let planets: [String] = ["planet_kepler_22b",
                                     "planet_kepler_1649c",
                                     "planet_proxima_b",
                                     "planet_ross_128b",
                                     "planet_teegarden_b"]
}

// MARK: - Life Cycles
extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
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
        planetCollectionView.prefetchDataSource = self
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
    }
}

// MARK: - CollectionViewDataSource
extension MainViewController: UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanetCell", for: indexPath) as? MainPlanetCell else {
            return UICollectionViewCell()
        }
        
        cell.setCellInfo(planet: planets[indexPath.row])
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
        let animation = Animation.named(planets[indexPath.row])
        planetCell.startAnimation(animation: animation)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let planetCell = cell as? MainPlanetCell else { return }
        planetCell.stopAnimaiont()
    }
}
