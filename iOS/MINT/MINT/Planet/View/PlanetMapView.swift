//
//  PlanetMapView.swift
//  MINT
//
//  Created by choymoon on 2022/04/04.
//

import UIKit

class PlanetMapView: UIView {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var backgroundImage: UIImage? {
        get { self.backgroundImageView.image }
        set { self.backgroundImageView.image = newValue }
    }
    
    let tileInfos: [PlanetTile]
    var tileViews: [PlanetTileView] = []
    
    init(tileInfos: [PlanetTile]) {
        self.tileInfos = tileInfos
        super.init(frame: .zero)
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.backgroundColor = .black.withAlphaComponent(0.3)
        
        self.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        setTileViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTileViews() {}
    
    func selectTile(withId tileId: String) {
        for tile in tileViews {
            if tile.tileId == tileId {
                tile.setSelected(true)
            } else {
                tile.setSelected(false)
            }
        }
    }
}
