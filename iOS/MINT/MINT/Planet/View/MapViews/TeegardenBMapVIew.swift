//
//  TeegardenBMapVIew.swift
//  MINT
//
//  Created by choymoon on 2022/04/04.
//

import UIKit

class TeegardenBMapView: PlanetMapView {
    
    override func setTileViews() {
        let planetShortId = "TG"
        
        // MARK: - Tile A
        let firstATitle = "\(planetShortId)-A-001"
        let firstAInfo = self.tileInfos.first { info in
            info.tileId == firstATitle
        }!
        
        let firstAtile = PlanetTileView(planetTile: firstAInfo)
        self.tileViews.append(firstAtile)
        
        self.addSubview(firstAtile)
        firstAtile.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalTo(firstAtile.snp.height)
        }
        
        var tileViewsA: [PlanetTileView] = []
        
        for num in 2...7 {
            let title = "\(planetShortId)-A-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsA.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsA)
        
        let aSubStackView1 = UIStackView(arrangedSubviews: [tileViewsA[0], tileViewsA[1]])
        aSubStackView1.axis = .horizontal
        aSubStackView1.spacing = 0
        aSubStackView1.distribution = .fillEqually
        
        let aSubStackView2 = UIStackView(arrangedSubviews: [tileViewsA[2], tileViewsA[3]])
        aSubStackView2.axis = .horizontal
        aSubStackView2.spacing = 0
        aSubStackView2.distribution = .fillEqually
        
        let aSubStackView3 = UIStackView(arrangedSubviews: [tileViewsA[4], tileViewsA[5]])
        aSubStackView3.axis = .horizontal
        aSubStackView3.spacing = 0
        aSubStackView3.distribution = .fillEqually
        
        let aStackView = UIStackView(arrangedSubviews: [aSubStackView1, aSubStackView2, aSubStackView3])
        aStackView.axis = .vertical
        aStackView.spacing = 0
        aStackView.distribution = .fillEqually
        
        self.addSubview(aStackView)
        aStackView.snp.makeConstraints { make in
            make.top.equalTo(firstAtile.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalTo(firstAtile)
            make.bottom.equalToSuperview()
        }
        
        // MARK: - Tile B
        var tileViewsB: [PlanetTileView] = []
        
        for num in 1...6 {
            let title = "\(planetShortId)-B-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsB.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsB)
        
        let bSubStackView1 = UIStackView(arrangedSubviews: [tileViewsB[0], tileViewsB[1], tileViewsB[2]])
        bSubStackView1.axis = .horizontal
        bSubStackView1.spacing = 0
        bSubStackView1.distribution = .fillEqually
        
        let bSubStackView2 = UIStackView(arrangedSubviews: [tileViewsB[3], tileViewsB[4], tileViewsB[5]])
        bSubStackView2.axis = .horizontal
        bSubStackView2.spacing = 0
        bSubStackView2.distribution = .fillEqually
        
        let bStackView = UIStackView(arrangedSubviews: [bSubStackView1, bSubStackView2])
        bStackView.axis = .vertical
        bStackView.spacing = 0
        bStackView.distribution = .fillEqually
        
        self.addSubview(bStackView)
        bStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(firstAtile.snp.right)
            make.height.equalTo(firstAtile)
            make.width.equalToSuperview().dividedBy(3)
        }
        
        // MARK: - Tile C
        let firstCTitle = "\(planetShortId)-C-001"
        let firstCInfo = self.tileInfos.first { info in
            info.tileId == firstCTitle
        }!
        
        let firstCtile = PlanetTileView(planetTile: firstCInfo)
        self.tileViews.append(firstCtile)
        
        self.addSubview(firstCtile)
        firstCtile.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(bStackView.snp.right)
            make.bottom.equalTo(bStackView)
            make.width.equalTo(firstAtile)
        }
        
        var tileViewsC: [PlanetTileView] = []
        
        for num in 2...5 {
            let title = "\(planetShortId)-C-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsC.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsC)
        
        let cSubStackView1 = UIStackView(arrangedSubviews: [tileViewsC[0], tileViewsC[1]])
        cSubStackView1.axis = .horizontal
        cSubStackView1.spacing = 0
        cSubStackView1.distribution = .fillEqually
        
        let cSubStackView2 = UIStackView(arrangedSubviews: [tileViewsC[2], tileViewsC[3]])
        cSubStackView2.axis = .horizontal
        cSubStackView2.spacing = 0
        cSubStackView2.distribution = .fillEqually
        
        let cStackView = UIStackView(arrangedSubviews: [cSubStackView1, cSubStackView2])
        cStackView.axis = .vertical
        cStackView.spacing = 0
        cStackView.distribution = .fillEqually
        
        self.addSubview(cStackView)
        cStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(firstCtile.snp.right)
            make.right.equalToSuperview()
            make.bottom.equalTo(firstCtile)
        }
        
        // MARK: - Tile D
        var tileViewsD: [PlanetTileView] = []
        
        for num in 1...3 {
            let title = "\(planetShortId)-D-00\(num)"
            let tile = self.tileInfos.first { info in
                info.tileId == title
            }
            tileViewsD.append(PlanetTileView(planetTile: tile!))
        }
        self.tileViews.append(contentsOf: tileViewsD)
        
        let dStackView = UIStackView(arrangedSubviews: [tileViewsD[0], tileViewsD[1]])
        dStackView.axis = .horizontal
        dStackView.spacing = 0
        dStackView.distribution = .fillEqually
        
        self.addSubview(dStackView)
        dStackView.snp.makeConstraints { make in
            make.top.equalTo(bStackView.snp.bottom)
            make.left.equalTo(aStackView.snp.right)
            make.height.equalTo(firstAtile).dividedBy(2)
            make.width.equalToSuperview().multipliedBy(0.222)
        }
        
        let lastDTile = tileViewsD[2]
        
        self.addSubview(lastDTile)
        lastDTile.snp.makeConstraints { make in
            make.top.equalTo(dStackView.snp.bottom)
            make.left.equalTo(aStackView.snp.right)
            make.height.equalTo(firstAtile)
            make.width.equalTo(firstAtile)
        }
        
        // MARK: - Tile E
        var tileViewsE: [PlanetTileView] = []
        
        for num in 1...3 {
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
            make.top.equalTo(bStackView.snp.bottom)
            make.left.equalTo(dStackView.snp.right)
            make.height.equalTo(firstAtile)
            make.width.equalTo(firstAtile)
        }
        
        let eStackView = UIStackView(arrangedSubviews: [tileViewsE[1], tileViewsE[2]])
        eStackView.axis = .horizontal
        eStackView.spacing = 0
        eStackView.distribution = .fillEqually
        
        self.addSubview(eStackView)
        eStackView.snp.makeConstraints { make in
            make.top.equalTo(firstETile.snp.bottom)
            make.left.equalTo(dStackView.snp.right)
            make.height.equalTo(firstAtile).dividedBy(2)
            make.width.equalTo(firstAtile)
        }
        
        // MARK: - Tile F
        let tileFTitle = "\(planetShortId)-F-001"
        let tileFInfo = self.tileInfos.first { info in
            info.tileId == tileFTitle
        }!
        
        let tileF = PlanetTileView(planetTile: tileFInfo)
        self.tileViews.append(tileF)
        
        self.addSubview(tileF)
        tileF.snp.makeConstraints { make in
            make.top.equalTo(cStackView.snp.bottom)
            make.left.equalTo(eStackView.snp.right)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
