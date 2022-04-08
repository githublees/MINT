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
    
    private let planetContentLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.semiBold, size: 15.3)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(planetAnimationView)
        
        planetAnimationView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(planetAnimationView.snp.width).multipliedBy(0.9)
        }
        
        self.addSubview(planetTitleLabel)
        
        planetTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(planetAnimationView).offset(40)
        }
        
        self.addSubview(planetContentLabel)
        
        planetContentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.top.equalTo(planetTitleLabel.snp.bottom).offset(14)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.planetAnimationView.animation = nil
    }
    
    public func setCellInfo(planet: Planet) {
        self.planetTitleLabel.text = planet.name.uppercased()
        
        let newContents = planet.content.split(separator: " ")
        
        var resultContent = ""
        for str in newContents {
            if str == "<br>"{
                resultContent += " "
            } else if str == "<br>\r" {
                resultContent += "\n"
            } else {
                resultContent += String(str)
                resultContent += " "
            }
        }
        
        self.planetContentLabel.text = resultContent
    }
    
    public func startAnimation(animation: String) {
        if self.planetAnimationView.animation == nil {
            OperationQueue().addOperation {
                let animation = Animation.named("planet_" + animation.lowercased(), animationCache: LRUAnimationCache.sharedCache)
                
                DispatchQueue.main.async {
                    self.planetAnimationView.animation = animation
                    self.planetAnimationView.play(completion: nil)
                }
            }
        } else {
            self.planetAnimationView.play(completion: nil)
        }
    }
    
    public func stopAnimaiont() {
        self.planetAnimationView.stop()
    }
}
