<h1 align=center>Arabam.com Case 📰 </h1> 

I model the data I got from a advert site and transferred it to the application with async / await URLSessions. I created a detail page for the advert and showed the pictures by downloading them with Kingfisher. I made the auto layout of the application Storyboard with .xib . In addition, i made the page transitions with Hero. I hope you like.

## Technologies
+ MVVM Architecture ✅ 
+ Storyboard and .xib ✅
+ Async/Await ✅ 
+ Generic URLSessions Layer ✅ 
+ CoreData ✅
+ CollectionView ✅
+ TableView ✅
+ Kingfisher ✅ 
+ Unit Test ✅ 

## Demo
![Simulator Screenshot - iPhone 14](https://user-images.githubusercontent.com/80515499/233509655-7221a02a-cb80-45d9-945f-d7d3612a69b8.png)

https://user-images.githubusercontent.com/80515499/233509444-1179a770-a258-41ab-b0e3-54ddaa1fbe40.mp4 

https://user-images.githubusercontent.com/80515499/233509450-1ae51643-e98e-4842-85aa-7ba423361732.mp4

Async / Await

```` swift
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
````
## MainViewController-ViewModel

Uygulamanın ilk ekranında, viewModel ve viewController arasında protokol&delegate methodu ile veri taşıma işlemi gerçekleştirdim.

```` swift
protocol AdvertViewModelDelegate: AnyObject {
    func didFetchData(advert: AdvertModel)
    func didFailWithError(error: Error)
}
--------------------------------------------------------
    internal func fetchData(take: Int) {
          Task(priority: .background) { [weak self] in
              guard let self = self else { return }
              do {
                  let result = await self.service.getAdvert(sort: 1, sortDirection: 0, take: take)
                  DispatchQueue.main.async { [weak self] in
                      guard let self = self else { return }
                      switch result {
                      case .success(let response):
                          self.advert = response 
                          self.delegate?.didFetchData(advert: advert) 
                      case .failure(let error):
                          self.delegate?.didFailWithError(error: error) 
                      }
                  }
              }
````
Burada kullanmış olduğum delegate&protokol yapısı sayesinde, viewController'a sadece .success ve .failture değerlerimi dönebiliyorum.

## DetailViewController-ViewModel

Detay ekranında ise farklı bir yöntem olarak closure yapısını kullandım.
```` swift
     var fetchAdvertDetail: ((AdvertDetail) -> Void)?
    
     func getData(id: String){
         fetchDetailData(id: id, successHandler: fetchAdvertDetail)
     }
     private func fetchDetailData(id: String, successHandler: ((AdvertDetail) -> Void)?) {
        Task(priority: .background) { [weak self] in
            guard let self = self else { return }
            do {
                let result = await AdvertService.shared.getAdvertDetail(id: id)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    switch result {
                    case .success(let response):
                        successHandler?(response)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
````
Yaptığım case içerisinde her iki yöntemi de kullanarak nasıl kullanıldığını göstermek istedim.
Eğer yaptığınız çalışmada "hangi yöntemi kullansam?" sorusuyla karşı karşıyaysanız, caseimi incelemenizi tavsiye ederim 🙂

## Unit Test 

```` swift

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
````
(Bu repo güncellenecek ve favori ilanlar sekmesi eklenecektir.)
                  
