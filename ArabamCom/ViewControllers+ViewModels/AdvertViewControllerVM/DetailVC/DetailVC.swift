//
//  AdvertDetailViewController.swift
//  ArabamCom
//
//  Created by Muhammet  on 19.04.2023.
//

import UIKit

class AdvertDetailViewController: UIViewController {

    private var advertDetail: AdvertDetail!
    private var service: AdvertServiceable!
    var viewModel: AdvertDetailViewModel!
    
    init(viewModel: AdvertDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        service = AdvertService()
        viewModel.delegate = self
        fetchData()
     
    }
}
extension AdvertDetailViewController: AdvertDetailViewModelDelegate {

    func didFetchData(advertDetail: AdvertDetail) {
        DispatchQueue.main.async {
            self.advertDetail = advertDetail
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }

    func didSelectedAdvertFavori(advertID: Int) {
        viewModel.fetchData()
    }
    fileprivate func fetchData(){
        viewModel.fetchData()
    }
}
