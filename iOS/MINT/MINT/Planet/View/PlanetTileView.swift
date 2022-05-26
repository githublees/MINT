//
//  PlanetTile.swift
//  MINT
//
//  Created by choymoon on 2022/04/04.
//

import UIKit

import Kingfisher

// MARK: - Variables & Initializer
class PlanetTileView: UIView {
    
    // Views
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let selectCheckView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightestMain
        view.alpha = 0
        return view
    }()
    
    var backgroundImage: UIImage? {
        get { self.backgroundImageView.image }
        set { self.backgroundImageView.image = newValue }
    }
    
    var backgroundImageContentMode: ContentMode {
        get { self.backgroundImageView.contentMode }
        set { self.backgroundImageView.contentMode = newValue }
    }
    
    private var _selected: Bool = false
    
    var selected: Bool {
        get { self._selected }
        set {
            if _selected != newValue {
                self.setSelected(newValue)
            }
            self._selected = newValue
        }
    }
    
    // Variables
    private var tileInfo: PlanetTile
    
    var info: PlanetTile? {
        get { self.tileInfo }
    }
    var tileId: String { self.tileInfo.tileId }
    
    init(planetTile tileInfo: PlanetTile) {
        self.tileInfo = tileInfo
        super.init(frame: .zero)
        self.alpha = 0.8
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.white.cgColor
        
        self.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        if let image = tileInfo.imageURL {
            let url = "http://j6a106.p.ssafy.io/api/image/display?filename=\(image)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            backgroundImageView.kf.setImage(with: URL(string: url))
        }
        
        self.addSubview(selectCheckView)
        selectCheckView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setSelected(_ selected: Bool) {
        switch selected {
        case true:
            selectCheckView.alpha = 0.5
        case false:
            selectCheckView.alpha = 0
        }
    }
}
