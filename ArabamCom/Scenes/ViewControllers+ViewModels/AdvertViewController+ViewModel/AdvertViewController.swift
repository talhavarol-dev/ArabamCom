//
//  AdvertViewController.swift
//  ArabamCom
//
//  Created by Muhammet  on 16.04.2023.
//

import UIKit
final class AdvertViewController: UIViewController {
    //MARK: Veriable
    private var advert: AdvertModel = []
    private var service: AdvertServiceable!
    private var viewModel: AdvertViewModel!
    private var currentTake: Int = 15
    //MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        service = AdvertService()
        viewModel = AdvertViewModel(service: service)
        viewModel.delegate = self
        searchBar.delegate = self
        tableView.register(UINib(nibName: "AdvertCell", bundle: nil), forCellReuseIdentifier: "AdvertCell")
        fetchData()
    }
}
//MARK: Extension
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
        let advertDetailStoryBoard = UIStoryboard(name: "DetailViewController", bundle: nil)
        let detail = advertDetailStoryBoard.instantiateViewController(identifier: "DetailViewController") as! AdvertDetailViewController
        detail.advertID = selectedAdvert.id.description
        navigationController?.pushViewController(detail, animated: true)
    }
}

extension AdvertViewController: UIScrollViewDelegate{
    
    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - currentOffset <= 10.0 {
            currentTake += 10
            loadMoreData()
            
        }
    }
}
extension AdvertViewController: UISearchBarDelegate {
   internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 2 {
            let filteredAdvert = viewModel.advert.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            self.advert = filteredAdvert
            self.tableView.reloadData()
        } else {
            self.advert = viewModel.advert
            self.tableView.reloadData()
        }
    }
    
}

extension AdvertViewController: AdvertViewModelDelegate {

    internal func didFetchData(advert: AdvertModel) {
        DispatchQueue.main.async {
            if let searchText = self.searchBar.text, searchText.count >= 2 {
                let filteredAdvert = advert.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
                self.advert = filteredAdvert
            } else {
                self.advert = advert
            }
            self.tableView.reloadData()
        }

    }
    
    internal func didFailWithError(error: Error) {
        print(error)
    }
    
    fileprivate func fetchData(){
        viewModel.fetchData(take: currentTake)
    }
    fileprivate func loadMoreData() {
        let nextCurrent = currentTake
        viewModel.fetchData(take: nextCurrent)
    }
}
