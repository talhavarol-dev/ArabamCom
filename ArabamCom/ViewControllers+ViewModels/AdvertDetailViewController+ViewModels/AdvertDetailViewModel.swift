//
//  AdvertDetailViewModel.swift
//  ArabamCom
//
//  Created by Muhammet  on 19.04.2023.
//

import Foundation

protocol AdvertDetailViewModelDelegate: AnyObject {
    func didFetchData(advertDetail: AdvertDetail)
    func didFailWithError(error: Error)
}
final class AdvertDetailViewModel {
    
    let service: AdvertServiceable
    weak var delegate: AdvertDetailViewModelDelegate!
    var advertDetail: AdvertDetail!
    private var advertID: String
    
    init(service: AdvertServiceable, advertID: String) {
        self.service = service
        self.advertID = advertID.description
    }

    internal func fetchData() {
        print(self.advertID)
        Task(priority: .background) { [weak self] in
            guard let self = self else { return }
            do {
                let result = await self.service.getAdvertDetail(id: self.advertID)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    switch result {
                    case .success(let response):
                        self.advertDetail = response
                        print(advertDetail.photos)
                        self.delegate?.didFetchData(advertDetail: response) // Delegate ile bildir
                    case .failure(let error):
                        self.delegate?.didFailWithError(error: error) // Delegate ile hata bildir
                    }
                }
            }
        }
    }
  
}
