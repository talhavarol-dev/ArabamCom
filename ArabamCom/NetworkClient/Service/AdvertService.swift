//
//  VehicleService.swift
//  ArabamCom
//
//  Created by Muhammet  on 16.04.2023.
//

protocol AdvertServiceable {
    func getAdvert(sort: Int, sortDirection: Int, take: Int) async -> Result<AdvertModel, RequestError>
    func getAdvertDetail(id: String) async -> Result<AdvertDetail, RequestError>
}

struct AdvertService: HTTPClient, AdvertServiceable {
    public static var shared = AdvertService()
    
    func getAdvert(sort: Int, sortDirection: Int, take: Int) async -> Result<AdvertModel, RequestError> {
        let endpoint = AdvertEndpoint.advertListing(sort: sort, sortDirection: sortDirection, take: take)
        return await sendRequest(endpoint: endpoint, responseModel: AdvertModel.self)
    }

    func getAdvertDetail(id: String) async -> Result<AdvertDetail, RequestError>{
        return await sendRequest(endpoint: AdvertEndpoint.advertDetail(id: id), responseModel: AdvertDetail.self)
    }
}
