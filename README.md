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

(Bu repo güncellenecek ve favori ilanlar sekmesi eklenecektir.)
                  
