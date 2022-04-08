//
//  ContractNetworkResponse.swift
//  MINT
//
//  Created by choymoon on 2022/04/07.
//

import Foundation

struct GasFeeResponse: Codable {
    
    let status: String
    let message: String
    let result: EstimateGasFee
}

struct EstimateGasFee: Codable {
    
    let lastBlock: String
    let safeGasPrice: String
    let proposeGasPrice: String
    let fastGasPrice: String
    let suggestBaseFee: String
    
    private enum CodingKeys: String, CodingKey {
        case lastBlock = "LastBlock"
        case safeGasPrice = "SafeGasPrice"
        case proposeGasPrice = "ProposeGasPrice"
        case fastGasPrice = "FastGasPrice"
        case suggestBaseFee
    }
}
