//
//  Kepler22BMapView.swift
//  MINT
//
//  Created by choymoon on 2022/04/04.
//

import UIKit

class Kepler22BMapView: PlanetMapView {
    
    override func setTileViews() {
        let planetShortId = "KepB"
        
        // MARK: - Tile A
        var tileViewsA: [PlanetTileView] = []
        
        for num in 1...9 {
            let title = "\(planetShortId)-A-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsA.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsA)
        
        let aStackView = UIStackView(arrangedSubviews: tileViewsA)
        aStackView.axis = .horizontal
        aStackView.spacing = 0
        aStackView.distribution = .fillEqually
        
        self.addSubview(aStackView)
        aStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        // MARK: - Tile B
        var tileViewsB: [PlanetTileView] = []
        
        for num in 1...2 {
            let title = "\(planetShortId)-B-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsB.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsB)
        
        let bStackView = UIStackView(arrangedSubviews: tileViewsB)
        bStackView.axis = .vertical
        bStackView.spacing = 0
        bStackView.distribution = .fillEqually
        
        self.addSubview(bStackView)
        bStackView.snp.makeConstraints { make in
            make.top.equalTo(aStackView.snp.bottom)
            make.left.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalToSuperview().multipliedBy(0.111)
        }
        
        // MARK: - Tile C
        let tileCTitle = "\(planetShortId)-C-001"
        let tileCInfo = self.tileInfos.first { info in
            info.tileId == tileCTitle
        }!
        
        let tileC = PlanetTileView(planetTile: tileCInfo)
        self.tileViews.append(tileC)
        
        self.addSubview(tileC)
        tileC.snp.makeConstraints { make in
            make.top.equalTo(aStackView.snp.bottom)
            make.left.equalTo(bStackView.snp.right)
            make.height.equalTo(bStackView)
            make.width.equalTo(bStackView).multipliedBy(2)
        }
        
        // MARK: - Tile D
        let tileDTitle = "\(planetShortId)-D-001"
        let tileDInfo = self.tileInfos.first { info in
            info.tileId == tileDTitle
        }!
        
        let tileD = PlanetTileView(planetTile: tileDInfo)
        self.tileViews.append(tileD)
        
        self.addSubview(tileD)
        tileD.snp.makeConstraints { make in
            make.top.equalTo(bStackView.snp.bottom)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(bStackView).multipliedBy(2)
        }
        
        // MARK: - Tile E
        var tileViewsE: [PlanetTileView] = []
        
        for num in 1...2 {
            let title = "\(planetShortId)-E-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsE.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsE)
        
        let eStackView = UIStackView(arrangedSubviews: tileViewsE)
        eStackView.axis = .vertical
        eStackView.spacing = 0
        eStackView.distribution = .fillEqually
        
        self.addSubview(eStackView)
        eStackView.snp.makeConstraints { make in
            make.top.equalTo(tileC.snp.bottom)
            make.left.equalTo(tileD.snp.right)
            make.bottom.equalToSuperview()
            make.right.equalTo(tileC)
        }
        
        // MARK: - Tile F
        var tileViewsF: [PlanetTileView] = []
        
        for num in 1...5 {
            let title = "\(planetShortId)-F-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsF.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsF)
        
        let fSubStackView = UIStackView(arrangedSubviews: [tileViewsF[0], tileViewsF[1]])
        fSubStackView.axis = .horizontal
        fSubStackView.spacing = 0
        fSubStackView.distribution = .fillEqually
        
        let fSubStackViewTwo = UIStackView(arrangedSubviews: [tileViewsF[2], tileViewsF[3]])
        fSubStackViewTwo.axis = .horizontal
        fSubStackViewTwo.spacing = 0
        fSubStackViewTwo.distribution = .fillEqually
        
        
        let fStackView = UIStackView(arrangedSubviews: [fSubStackView, fSubStackViewTwo])
        fStackView.axis = .vertical
        fStackView.spacing = 0
        fStackView.distribution = .fillEqually
        
        self.addSubview(fStackView)
        fStackView.snp.makeConstraints { make in
            make.top.equalTo(aStackView.snp.bottom)
            make.left.equalTo(tileC.snp.right)
            make.height.equalTo(tileC)
            make.width.equalTo(tileC)
        }
        
        let lastFTile = tileViewsF[4]
        self.addSubview(lastFTile)
        lastFTile.snp.makeConstraints { make in
            make.top.equalTo(fStackView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalTo(fStackView)
            make.left.equalTo(eStackView.snp.right)
        }
        
        // MARK: - Tile G
        let tileGTitle = "\(planetShortId)-G-001"
        let tileGInfo = self.tileInfos.first { info in
            info.tileId == tileGTitle
        }!
        
        let tileG = PlanetTileView(planetTile: tileGInfo)
        self.tileViews.append(tileG)
        
        self.addSubview(tileG)
        tileG.snp.makeConstraints { make in
            make.top.equalTo(aStackView.snp.bottom)
            make.left.equalTo(fStackView.snp.right)
            make.width.equalToSuperview().multipliedBy(0.333)
            make.height.equalTo(tileG.snp.width)
        }
        
        // MARK: - Tile H
        var tileViewsH: [PlanetTileView] = []
        
        for num in 1...3 {
            let title = "\(planetShortId)-H-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsH.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsH)
        
        let hStackView = UIStackView(arrangedSubviews: tileViewsH)
        hStackView.axis = .vertical
        hStackView.spacing = 0
        hStackView.distribution = .fillEqually
        
        self.addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.top.equalTo(aStackView.snp.bottom)
            make.left.equalTo(tileG.snp.right)
            make.right.equalToSuperview()
            make.bottom.equalTo(tileG)
        }
        
        // MARK: - Tile I
        var tileViewsI: [PlanetTileView] = []
        
        for num in 1...4 {
            let title = "\(planetShortId)-I-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsI.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsI)
        
        let iStackView = UIStackView(arrangedSubviews: tileViewsI)
        iStackView.axis = .horizontal
        iStackView.spacing = 0
        iStackView.distribution = .fillEqually
        
        self.addSubview(iStackView)
        iStackView.snp.makeConstraints { make in
            make.top.equalTo(tileG.snp.bottom)
            make.left.equalTo(lastFTile.snp.right)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
