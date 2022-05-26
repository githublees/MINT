//
//  Kepler1649CMapView.swift
//  MINT
//
//  Created by choymoon on 2022/04/04.
//

import UIKit

class Kepler1649CMapView: PlanetMapView {
    
    override func setTileViews() {
        let planetShortId = "KepC"
        
        // MARK: - Tile A
        var tileViewsA: [PlanetTileView] = []
        
        for num in 1...9 {
            let title = "\(planetShortId)-A-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsA.append(PlanetTileView(planetTile: tile!))
        }
        for num in 10...12 {
            let title = "\(planetShortId)-A-0\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsA.append(PlanetTileView(planetTile: tile!))
        }
        
        self.tileViews.append(contentsOf: tileViewsA)
        
        let aSubStackView1 = UIStackView(arrangedSubviews: [tileViewsA[0], tileViewsA[1], tileViewsA[2], tileViewsA[3]])
        aSubStackView1.axis = .horizontal
        aSubStackView1.spacing = 0
        aSubStackView1.distribution = .fillEqually
        
        let aSubStackView2 = UIStackView(arrangedSubviews: [tileViewsA[4], tileViewsA[5], tileViewsA[6], tileViewsA[7]])
        aSubStackView2.axis = .horizontal
        aSubStackView2.spacing = 0
        aSubStackView2.distribution = .fillEqually
        
        let aSubStackView3 = UIStackView(arrangedSubviews: [tileViewsA[8], tileViewsA[9], tileViewsA[10], tileViewsA[11]])
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
            make.width.equalToSuperview().multipliedBy(0.444)
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
            make.top.equalToSuperview()
            make.left.equalTo(aStackView.snp.right)
            make.width.equalToSuperview().multipliedBy(0.222)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        let bStackView = UIStackView(arrangedSubviews: [tileViewsB[1], tileViewsB[2]])
        bStackView.axis = .horizontal
        bStackView.spacing = 0
        bStackView.distribution = .fillEqually
        
        self.addSubview(bStackView)
        bStackView.snp.makeConstraints { make in
            make.top.equalTo(firstBTile.snp.bottom)
            make.left.equalTo(aStackView.snp.right)
            make.right.equalTo(firstBTile)
            make.bottom.equalTo(aStackView)
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
            make.top.equalToSuperview()
            make.left.equalTo(firstBTile.snp.right)
            make.right.equalToSuperview()
            make.bottom.equalTo(bStackView)
        }
        
        // MARK: - Tile D
        var tileViewsD: [PlanetTileView] = []
        
        for num in 1...4 {
            let title = "\(planetShortId)-D-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsD.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsD)
        
        let dStackView1 = UIStackView(arrangedSubviews: [tileViewsD[0], tileViewsD[1]])
        dStackView1.axis = .horizontal
        dStackView1.spacing = 0
        dStackView1.distribution = .fillEqually
        
        let dStackView2 = UIStackView(arrangedSubviews: [tileViewsD[2], tileViewsD[3]])
        dStackView2.axis = .vertical
        dStackView2.spacing = 0
        dStackView2.distribution = .fillEqually
        
        self.addSubview(dStackView1)
        self.addSubview(dStackView2)
        
        dStackView1.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(aStackView.snp.bottom)
            make.bottom.equalToSuperview()
            make.right.equalTo(aStackView)
        }
        
        dStackView2.snp.makeConstraints { make in
            make.left.equalTo(dStackView1.snp.right)
            make.top.equalTo(bStackView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.111)
        }
        
        // MARK: - Tile E
        var tileViewsE: [PlanetTileView] = []
        
        for num in 1...5 {
            let title = "\(planetShortId)-E-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsE.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsE)
        
        let firstETile = tileViewsE[0]
        
        self.addSubview(firstETile)
        firstETile.snp.makeConstraints { make in
            make.left.equalTo(dStackView2.snp.right)
            make.top.equalTo(bStackView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.222)
        }
        
        let eSubStackView1 = UIStackView(arrangedSubviews: [tileViewsE[1], tileViewsE[2]])
        eSubStackView1.axis = .horizontal
        eSubStackView1.spacing = 0
        eSubStackView1.distribution = .fillEqually
        
        let eSubStackView2 = UIStackView(arrangedSubviews: [tileViewsE[3], tileViewsE[4]])
        eSubStackView2.axis = .horizontal
        eSubStackView2.spacing = 0
        eSubStackView2.distribution = .fillEqually
        
        let eStackView = UIStackView(arrangedSubviews: [eSubStackView1, eSubStackView2])
        eStackView.axis = .vertical
        eStackView.spacing = 0
        eStackView.distribution = .fillEqually
        
        self.addSubview(eStackView)
        eStackView.snp.makeConstraints { make in
            make.left.equalTo(firstETile.snp.right)
            make.top.equalTo(tileC.snp.bottom)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
