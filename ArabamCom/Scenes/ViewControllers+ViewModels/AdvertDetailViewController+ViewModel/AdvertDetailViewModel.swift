//
//  AdvertDetailViewModel.swift
//  ArabamCom
//
//  Created by Muhammet  on 19.04.2023.
//

import Foundation

 class AdvertDetailViewModel {
    
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
}


