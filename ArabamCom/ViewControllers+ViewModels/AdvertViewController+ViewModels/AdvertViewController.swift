//
//  AdvertViewController.swift
//  ArabamCom
//
//  Created by Muhammet  on 16.04.2023.
//

import UIKit
final class AdvertViewController: UIViewController {
    
    private var advert: AdvertModel = []
    private var service: AdvertServiceable!
    private var viewModel: AdvertViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var favoriItem: UITabBarItem!
    @IBOutlet weak var homeItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service = AdvertService()
        viewModel = AdvertViewModel(service: service)
        viewModel.delegate = self
        tableView.register(UINib(nibName: "AdvertCell", bundle: nil), forCellReuseIdentifier: "AdvertCell")
        // tableView.register(AdvertCell.self, forCellReuseIdentifier: "AdvertCell")
        fetchData()
        
    }
}

extension AdvertViewController: UITableViewDelegate, UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertCell") as! AdvertCell
        let model = advert[indexPath.row]
        cell.advertCellConfigure(model: model)
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return advert.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAdvert = advert[indexPath.row]
        let detailViewModel = AdvertDetailViewModel(service: service, advertID: selectedAdvert.id.description)
            let detailViewController = AdvertDetailViewController(viewModel: detailViewModel)
            navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension AdvertViewController: AdvertViewModelDelegate {

    internal func didFetchData(advert: AdvertModel) {
        DispatchQueue.main.async {
            self.advert = advert
            self.tableView.reloadData()
        }
    }
    
    internal func didFailWithError(error: Error) {
        print(error)
    }
    
    fileprivate func fetchData(){
        viewModel.fetchData()
    }
}

