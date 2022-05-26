//
//  TileNetworkResponse.swift
//  MINT
//
//  Created by choymoon on 2022/04/07.
//

import Foundation

struct TileBasicResponse: Codable {
    let statusCode: Int
    let message: String
}

struct FavoriteTile: Codable {
    let tileId: String
}
