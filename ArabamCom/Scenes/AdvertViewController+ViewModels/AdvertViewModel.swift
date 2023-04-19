//
//  VehicleViewModel.swift
//  ArabamCom
//
//  Created by Muhammet  on 16.04.2023.
//

import Foundation

protocol AdvertViewModelDelegate: AnyObject {
    func didFetchData(advert: AdvertModel)
    func didFailWithError(error: Error)
}

final class AdvertViewModel{
    private let service: AdvertServiceable
    weak var delegate: AdvertViewModelDelegate!
    lazy var advert: AdvertModel = []
    
    init(service: AdvertServiceable) {
        self.service = service
    }
    internal func fetchData() {
          Task(priority: .background) { [weak self] in
              guard let self = self else { return }
              do {
                  let result = await self.service.getAdvert(sort: 1, sortDirection: 0, take: 30)
                  DispatchQueue.main.async { [weak self] in
                      guard let self = self else { return }
                      switch result {
                      case .success(let response):
                          self.advert = response // advert dizisini güncelle
                          self.delegate?.didFetchData(advert: advert) // Delegate ile bildir
                      case .failure(let error):
                          self.delegate?.didFailWithError(error: error) // Delegate ile hata bildir
                      }
                  }
              }
          }
      }
}
