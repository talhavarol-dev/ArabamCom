//
//  Endpoint.swift
//  ArabamCom
//
//  Created by Muhammet  on 16.04.2023.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var params: [String: Any]? { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "sandbox.arabamd.com"
    }
}
