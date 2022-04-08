//
//  Ross128BMapView.swift
//  MINT
//
//  Created by choymoon on 2022/04/05.
//

import UIKit

class Ross128BMapView: PlanetMapView {
    
    override func setTileViews() {
        let planetShortId = "RB"
        
        // MARK: - Tile A
        var tileViewsA: [PlanetTileView] = []
        
        for num in 1...2 {
            let title = "\(planetShortId)-A-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsA.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsA)
        
        let aStackView = UIStackView(arrangedSubviews: tileViewsA)
        aStackView.axis = .vertical
        aStackView.spacing = 0
        aStackView.distribution = .fillEqually
        
        self.addSubview(aStackView)
        aStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalToSuperview().multipliedBy(0.111)
        }
        
        // MARK: - Tile B
        let firstBTitle = "\(planetShortId)-B-001"
        let firstBInfo = self.tileInfos.first { info in
            info.tileId == firstBTitle
        }!
        
        let firstBtile = PlanetTileView(planetTile: firstBInfo)
        self.tileViews.append(firstBtile)
        
        self.addSubview(firstBtile)
        firstBtile.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(aStackView.snp.right)
            make.bottom.equalTo(aStackView)
            make.width.equalToSuperview().multipliedBy(0.222)
        }
        
        // MARK: - Tile C
        var tileViewsC: [PlanetTileView] = []
        
        for num in 1...8 {
            let title = "\(planetShortId)-C-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsC.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsC)
        
        let cSubStackView1 = UIStackView(arrangedSubviews: [tileViewsC[0], tileViewsC[1], tileViewsC[2], tileViewsC[3]])
        cSubStackView1.axis = .horizontal
        cSubStackView1.spacing = 0
        cSubStackView1.distribution = .fillEqually
        
        let cSubStackView2 = UIStackView(arrangedSubviews: [tileViewsC[4], tileViewsC[5], tileViewsC[6], tileViewsC[7]])
        cSubStackView2.axis = .horizontal
        cSubStackView2.spacing = 0
        cSubStackView2.distribution = .fillEqually
        
        let cStackView = UIStackView(arrangedSubviews: [cSubStackView1, cSubStackView2])
        cStackView.axis = .vertical
        cStackView.spacing = 0
        cStackView.distribution = .fillEqually
        
        self.addSubview(cStackView)
        cStackView.snp.makeConstraints { make in
            make.left.equalTo(firstBtile.snp.right)
            make.top.equalToSuperview()
            make.bottom.equalTo(firstBtile)
            make.width.equalToSuperview().multipliedBy(0.444)
        }
        
        // MARK: - Tile D
        let firstDTitle = "\(planetShortId)-D-001"
        let firstDInfo = self.tileInfos.first { info in
            info.tileId == firstDTitle
        }!
        
        let firstDtile = PlanetTileView(planetTile: firstDInfo)
        self.tileViews.append(firstDtile)
        
        self.addSubview(firstDtile)
        firstDtile.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(cStackView.snp.right)
            make.bottom.equalTo(cStackView)
            make.width.equalToSuperview().multipliedBy(0.222)
        }
        
        // MARK: - Tile E
        let firstETitle = "\(planetShortId)-E-001"
        let firstEInfo = self.tileInfos.first { info in
            info.tileId == firstETitle
        }!
        
        let firstEtile = PlanetTileView(planetTile: firstEInfo)
        self.tileViews.append(firstEtile)
        
        self.addSubview(firstEtile)
        firstEtile.snp.makeConstraints { make in
            make.top.equalTo(aStackView.snp.bottom)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalTo(firstBtile)
        }
        
        // MARK: - Tile F
        var tileViewsF: [PlanetTileView] = []
        
        for num in 1...3 {
            let title = "\(planetShortId)-F-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsF.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsF)
        
        let fStackView = UIStackView(arrangedSubviews: [tileViewsF[0], tileViewsF[1]])
        fStackView.axis = .horizontal
        fStackView.spacing = 0
        fStackView.distribution = .fillEqually
        
        self.addSubview(fStackView)
        fStackView.snp.makeConstraints { make in
            make.left.equalTo(firstEtile.snp.right)
            make.top.equalTo(cStackView.snp.bottom)
            make.width.equalTo(cStackView).multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        let lastFTile = tileViewsF[2]
        self.addSubview(lastFTile)
        lastFTile.snp.makeConstraints { make in
            make.left.equalTo(fStackView)
            make.top.equalTo(fStackView.snp.bottom)
            make.right.equalTo(fStackView)
            make.bottom.equalToSuperview()
        }
        
        // MARK: - Tile G
        var tileViewsG: [PlanetTileView] = []
        
        for num in 1...3 {
            let title = "\(planetShortId)-G-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsG.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsG)
        
        let firstGTile = tileViewsG[0]
        self.addSubview(firstGTile)
        firstGTile.snp.makeConstraints { make in
            make.left.equalTo(fStackView.snp.right)
            make.top.equalTo(cStackView.snp.bottom)
            make.right.equalTo(cStackView)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        let gStackView = UIStackView(arrangedSubviews: [tileViewsG[1], tileViewsG[2]])
        gStackView.axis = .horizontal
        gStackView.spacing = 0
        gStackView.distribution = .fillEqually
        
        self.addSubview(gStackView)
        gStackView.snp.makeConstraints { make in
            make.left.equalTo(fStackView.snp.right)
            make.top.equalTo(firstGTile.snp.bottom)
            make.right.equalTo(firstGTile)
            make.bottom.equalToSuperview()
        }
        
        // MARK: - Tile H
        var tileViewsH: [PlanetTileView] = []
        
        for num in 1...6 {
            let title = "\(planetShortId)-H-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsH.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsH)
        
        let hSubStackView1 = UIStackView(arrangedSubviews: [tileViewsH[0], tileViewsH[2], tileViewsH[4]])
        hSubStackView1.axis = .vertical
        hSubStackView1.spacing = 0
        hSubStackView1.distribution = .fillEqually
        
        let hSubStackView2 = UIStackView(arrangedSubviews: [tileViewsH[1], tileViewsH[3], tileViewsH[5]])
        hSubStackView2.axis = .vertical
        hSubStackView2.spacing = 0
        hSubStackView2.distribution = .fillEqually
        
        let hStackView = UIStackView(arrangedSubviews: [hSubStackView1, hSubStackView2])
        hStackView.axis = .horizontal
        hStackView.spacing = 0
        hStackView.distribution = .fillEqually
        
        self.addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.left.equalTo(gStackView.snp.right)
            make.top.equalTo(firstDtile.snp.bottom)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
