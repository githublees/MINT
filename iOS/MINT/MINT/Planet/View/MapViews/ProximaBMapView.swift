//
//  ProximaBMapView.swift
//  MINT
//
//  Created by choymoon on 2022/04/05.
//

import UIKit

class ProximaBMapView: PlanetMapView {
     
    override func setTileViews() {
        let planetShortId = "PrxB"
        
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
        
        let aSubStackView1 = UIStackView(arrangedSubviews: [tileViewsA[0], tileViewsA[1], tileViewsA[2]])
        aSubStackView1.axis = .horizontal
        aSubStackView1.spacing = 0
        aSubStackView1.distribution = .fillEqually
        
        let aSubStackView2 = UIStackView(arrangedSubviews: [tileViewsA[3], tileViewsA[4], tileViewsA[5]])
        aSubStackView2.axis = .horizontal
        aSubStackView2.spacing = 0
        aSubStackView2.distribution = .fillEqually
        
        let aSubStackView3 = UIStackView(arrangedSubviews: [tileViewsA[6], tileViewsA[7], tileViewsA[8]])
        aSubStackView3.axis = .horizontal
        aSubStackView3.spacing = 0
        aSubStackView3.distribution = .fillEqually
        
        let aStackView = UIStackView(arrangedSubviews: [aSubStackView1, aSubStackView2, aSubStackView3])
        aStackView.axis = .vertical
        aStackView.spacing = 0
        aStackView.distribution = .fillEqually
        
        self.addSubview(aStackView)
        aStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.333)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        // MARK: - Tile B
        var tileViewsB: [PlanetTileView] = []
        
        for num in 1...3 {
            let title = "\(planetShortId)-B-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsB.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsB)
        
        let firstBTile = tileViewsB[0]
        
        self.addSubview(firstBTile)
        firstBTile.snp.makeConstraints { make in
            make.left.equalTo(aStackView.snp.right)
            make.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.222)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        let bStackView = UIStackView(arrangedSubviews: [tileViewsB[1], tileViewsB[2]])
        bStackView.axis = .horizontal
        bStackView.spacing = 0
        bStackView.distribution = .fillEqually
        
        self.addSubview(bStackView)
        bStackView.snp.makeConstraints { make in
            make.left.equalTo(firstBTile)
            make.top.equalTo(firstBTile.snp.bottom)
            make.bottom.equalTo(aStackView)
            make.right.equalTo(firstBTile)
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
            make.left.equalTo(firstBTile.snp.right)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(firstBTile)
        }
        
        // MARK: - Tile D
        var tileViewsD: [PlanetTileView] = []
        
        for num in 1...2 {
            let title = "\(planetShortId)-D-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsD.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsD)
        
        let dStackView = UIStackView(arrangedSubviews: tileViewsD)
        dStackView.axis = .vertical
        dStackView.spacing = 0
        dStackView.distribution = .fillEqually
        
        self.addSubview(dStackView)
        dStackView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(aStackView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.111)
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
        eStackView.axis = .horizontal
        eStackView.spacing = 0
        eStackView.distribution = .fillEqually
        
        self.addSubview(eStackView)
        eStackView.snp.makeConstraints { make in
            make.left.equalTo(dStackView.snp.right)
            make.top.equalTo(aStackView.snp.bottom)
            make.bottom.equalToSuperview()
            make.right.equalTo(bStackView)
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
        
        let firstFTile = tileViewsF[0]
        
        self.addSubview(firstFTile)
        firstFTile.snp.makeConstraints { make in
            make.left.equalTo(bStackView.snp.right)
            make.top.equalTo(cStackView.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalTo(cStackView).multipliedBy(0.5)
        }
        
        let fStackView = UIStackView(arrangedSubviews: [tileViewsF[1], tileViewsF[2]])
        fStackView.axis = .horizontal
        fStackView.spacing = 0
        fStackView.distribution = .fillEqually
        
        self.addSubview(fStackView)
        fStackView.snp.makeConstraints { make in
            make.left.equalTo(eStackView.snp.right)
            make.top.equalTo(firstFTile.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalTo(firstFTile)
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
        
        let gStackView = UIStackView(arrangedSubviews: [tileViewsG[0], tileViewsG[1]])
        gStackView.axis = .horizontal
        gStackView.spacing = 0
        gStackView.distribution = .fillEqually
        
        self.addSubview(gStackView)
        gStackView.snp.makeConstraints { make in
            make.left.equalTo(firstFTile.snp.right)
            make.right.equalToSuperview()
            make.top.equalTo(cStackView.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        let lastGTile = tileViewsG[2]
        
        self.addSubview(lastGTile)
        lastGTile.snp.makeConstraints { make in
            make.top.equalTo(gStackView.snp.bottom)
            make.left.equalTo(fStackView.snp.right)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
