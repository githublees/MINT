//
//  ContractNetworkService.swift
//  MINT
//
//  Created by choymoon on 2022/04/07.
//

import Foundation

import Moya

enum ContractNetworkService {
    
    case estimateGasFee
}

extension ContractNetworkService: TargetType {
    
    private static let apiKey = "FV9R3FEM9KS7M8TH9MUUHQRINPK7XVZDMM"
    
    var baseURL: URL {
        guard let url = URL(string: "https://api-ropsten.etherscan.io/api") else {
            fatalError("Wrong URL : Planet")
        }
        return url
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        switch self {
        case .estimateGasFee:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .estimateGasFee:
            return .requestParameters(parameters: ["module" : "gastracker",
                                                   "action" : "gasoracle",
                                                   "apikey" : ContractNetworkService.apiKey],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
