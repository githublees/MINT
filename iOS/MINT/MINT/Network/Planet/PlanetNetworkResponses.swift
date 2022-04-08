//
//  PlanetNetworkResponses.swift
//  MINT
//
//  Created by choymoon on 2022/03/29.
//

import Foundation

struct PlanetResponse: Codable {
    
    let planet: [Planet]
}

struct Planet: Codable {
    
    let pid: Int
    let name: String
    let diameter: Double
    let mass: Double
    let galaxy: String
    let content: String
    let totalCell: Int
}

struct PlanetTileResponse: Codable {
    
    let tiles: [PlanetTile]
}

struct PlanetTile: Codable {
    let area: Int
    let buyerAddress: String?
    let imageURL: String?
    let planetId: Int
    let price: Double
    let tileId: String
    let tokenId: String?
    let tradeDate: String?
    
    private enum CodingKeys: String, CodingKey {
        case area, price, tokenId, tradeDate
        case buyerAddress = "buyerAdr"
        case imageURL = "image"
        case planetId = "planet"
        case tileId = "tid"
    }
}
