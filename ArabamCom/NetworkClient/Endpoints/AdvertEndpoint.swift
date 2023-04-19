//
//  VehicleEndpoint.swift
//  ArabamCom
//
//  Created by Muhammet  on 16.04.2023.
//

import Foundation
enum AdvertEndpoint {
    case advertListing(sort: Int, sortDirection: Int, take: Int)
    case advertDetail(id: String)
}

extension AdvertEndpoint: Endpoint {
    var header: [String : String]? {
        [:]
    }

    var path: String {
        switch self {
        case .advertListing:
            return "/api/v1/listing"
        case .advertDetail(_):
            return "/api/v1/detail" // /detail/id formatında güncelledim
        }
    }

    var method: RequestMethod {
        switch self {
        case .advertListing, .advertDetail:
            return .get
        }
    }

    var body: [String: String]? {
        switch self {
        case .advertListing, .advertDetail:
            return nil
        }
    }

    var params: [String: Any]? {
        switch self {
        case .advertListing(let sort, let sortDirection, let take):
            return ["sort": sort, "sortDirection": sortDirection, "take": take]
        case .advertDetail(let value):
            return ["id": value as String]
        }
    }}

