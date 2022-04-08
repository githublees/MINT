//
//  PlanetTileCellDelegate.swift
//  MINT
//
//  Created by choymoon on 2022/04/06.
//

import Foundation

protocol PlanetTileCellDelegate {
    func tileSelected(with tileId: String)
    func openTileContractViewController(with tileInfo: PlanetTile)
}

