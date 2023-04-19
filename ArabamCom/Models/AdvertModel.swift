//
//  VehicleModels.swift
//  ArabamCom
//
//  Created by Muhammet  on 16.04.2023.
//

import Foundation

struct Advert: Codable {
    let id: Int
    let title: String
    let location: Location
    let category: Category
    let modelName: String
    let price: Int
    let priceFormatted, date, dateFormatted, photo: String
    let properties: [Property]
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let name: String
}

// MARK: - Location
struct Location: Codable {
    var cityName, townName: String
}

// MARK: - Property
struct Property: Codable {
    let name, value: String
}

typealias AdvertModel = [Advert]
