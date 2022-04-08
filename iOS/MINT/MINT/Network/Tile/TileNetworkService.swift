//
//  TileNetworkService.swift
//  MINT
//
//  Created by choymoon on 2022/04/05.
//

import Foundation

import Moya

enum TileNetworkService {
    
    case addFavorite(tileId: String, walletId: String)
    case removeFavorite(tileId: String, walletId: String)
    case favoriteList(walletId: String)
    case getTileInfo(tileId: String)
}

extension TileNetworkService: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "http://j6a106.p.ssafy.io/api") else {
            fatalError("Wrong URL : Planet")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .addFavorite:
            return "/favorite"
        case .removeFavorite(let tileId, let walletId):
            return "/favorite/\(walletId)/\(tileId)"
        case .favoriteList(let walletId):
            return "/favorite/\(walletId)"
        case .getTileInfo(let tileId):
            return "/tile/\(tileId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addFavorite:
            return .post
        case .removeFavorite:
            return .delete
        case .favoriteList, .getTileInfo:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .addFavorite(let tileId, let walletId):
            return .requestParameters(parameters: ["tileId" : tileId,
                                                   "walletId" : walletId],
                                      encoding: JSONEncoding.prettyPrinted)
        case .removeFavorite, .favoriteList, .getTileInfo:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
}
