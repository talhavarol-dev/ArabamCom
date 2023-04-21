//
//  MainViewModel_test.swift
//  ArabamComTests
//
//  Created by Muhammet  on 21.04.2023.
//

import XCTest
@testable import ArabamCom

class MainViewModelTests: XCTestCase {
    
    var viewModel: AdvertViewModel!
    var service: MockLeagueService!
    
    override func setUp() {
        super.setUp()
        service = MockLeagueService()
        viewModel = AdvertViewModel(service: service)
    }
    func testFetchDataSuccess() async throws {
        let mockData = [
        Advert(id: 1, title: "Mock Advert 1", location: Location(cityName: "Istanbul", townName: "Kadikoy"), category: Category(id: 1, name: "Category 1"), modelName: "Model 1", price: 1000, priceFormatted: "1,000 TL", date: "2022-04-22T10:20:30Z", dateFormatted: "22 Nisan 2022", photo: "https://via.placeholder.com/150", properties: [Property(name: "Property 1", value: "Value 1"), Property(name: "Property 2", value: "Value 2")]),
        Advert(id: 2, title: "Mock Advert 2", location: Location(cityName: "Istanbul", townName: "Besiktas"), category: Category(id: 2, name: "Category 2"), modelName: "Model 2", price: 2000, priceFormatted: "2,000 TL", date: "2022-04-21T09:10:20Z", dateFormatted: "21 Nisan 2022", photo: "https://via.placeholder.com/150", properties: [Property(name: "Property 3", value: "Value 3"), Property(name: "Property 4", value: "Value 4")]),
        Advert(id: 3, title: "Mock Advert 3", location: Location(cityName: "Ankara", townName: "Cankaya"), category: Category(id: 3, name: "Category 3"), modelName: "Model 3", price: 3000, priceFormatted: "3,000 TL", date: "2022-04-20T08:09:10Z", dateFormatted: "20 Nisan 2022", photo: "https://via.placeholder.com/150", properties: [Property(name: "Property 5", value: "Value 5"), Property(name: "Property 6", value: "Value 6")])
               ]
  
        XCTAssertEqual(mockData.count, 3)
        XCTAssertEqual(mockData[0].title, "Mock Advert 1")
        XCTAssertEqual(mockData[1].modelName, "Model 2")
        XCTAssertEqual(mockData[2].category.name, "Category 3")

    }
}
class MockLeagueService: AdvertServiceable {
    
    var mockResult: Result<AdvertModel, RequestError>?
    var mockResultDetail: Result<AdvertDetail, RequestError>?
    
    func getAdvert(sort: Int, sortDirection: Int, take: Int) async -> Result<ArabamCom.AdvertModel, ArabamCom.RequestError> {
        return mockResult ?? .failure(RequestError.unknown)
    }
    
    func getAdvertDetail(id: String) async -> Result<ArabamCom.AdvertDetail, ArabamCom.RequestError> {
        return mockResultDetail ?? .failure(RequestError.unknown)
    }
}

