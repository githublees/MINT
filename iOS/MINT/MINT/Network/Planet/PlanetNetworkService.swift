//
//  PlanetNetworkService.swift
//  MINT
//
//  Created by choymoon on 2022/03/28.
//

import Foundation

import Moya

enum PlanetNetworkService {
    
    case planets
    case planetTiles(planetId: Int)
    case planetRemainTiles(planetId: Int)
}

extension PlanetNetworkService: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "http://j6a106.p.ssafy.io/api") else {
            fatalError("Wrong URL : Planet")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .planets:
            return "/planets"
        case .planetTiles(let id):
            return "/all/\(id)"
        case .planetRemainTiles(let id):
            return "/remain/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
}
