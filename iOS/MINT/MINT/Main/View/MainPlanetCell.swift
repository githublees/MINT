//
//  MainPlanetCell.swift
//  MINT
//
//  Created by choymoon on 2022/03/23.
//

import UIKit

import Lottie

class MainPlanetCell: UICollectionViewCell {
    
    private let planetAnimationView: AnimationView = {
        let view = AnimationView()
        view.backgroundColor = .clear
        view.loopMode = .loop
        return view
    }()
    
    private let planetTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .rubikOne(size: 28)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(planetAnimationView)
        
        planetAnimationView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(planetAnimationView.snp.width)
        }
        
        self.addSubview(planetTitleLabel)
        
        planetTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(planetAnimationView).offset(40)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setCellInfo(planet: String) {
        let title: String = String(planet.suffix(from: planet.index(planet.startIndex, offsetBy: 7)))
        self.planetTitleLabel.text = title.uppercased()
    }
    
    public func startAnimation(animation: Animation?) {
        self.planetAnimationView.animation = animation
        self.planetAnimationView.play(completion: nil)
    }
    
    public func stopAnimaiont() {
        self.planetAnimationView.stop()
        self.planetAnimationView.animation = nil
    }
}
