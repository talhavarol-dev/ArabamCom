//
//  AdvertDetailViewController.swift
//  ArabamCom
//
//  Created by Muhammet  on 19.04.2023.
//

import UIKit

class AdvertDetailViewController: UIViewController {
    //MARK: Veriable
    var advertDetail: AdvertDetail?
    private var viewModel = AdvertDetailViewModel()
    var advertID: String?
    
    //MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderTableViewCell")
        tableView.register(UINib(nibName: "BodyTableViewCell", bundle: nil), forCellReuseIdentifier: "BodyTableViewCell")
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        title = "İlan Detayı"
        fetchData()
    }
    private func fetchData() {
        guard let id = advertID else { return }
        viewModel.fetchAdvertDetail = {[ weak self ] response in
            guard let self = self else {return}
            self.advertDetail = response
            self.tableView.reloadData()
        }
        viewModel.getData(id: id)
    }
}
//MARK: Extension
extension AdvertDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let advertCount = advertDetail?.properties.count else {
            return 0
        }
        return advertCount + 3
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
            cell.location = advertDetail?.location
            cell.nameLabel.text = advertDetail?.userInfo.nameSurname
            cell.categoryLabel.text = advertDetail?.category.name
            cell.photoArray = advertDetail?.photos
            return cell
            
        }else if indexPath.row <= advertDetail?.properties.count ?? 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BodyTableViewCell", for: indexPath) as! BodyTableViewCell
            if let property = advertDetail?.properties[indexPath.row - 1] {
                cell.keyLabel.text = property.name
                cell.valueLabel.text = property.value
            } else {
                cell.keyLabel.text = nil
                cell.valueLabel.text = nil
            }
            return cell
            
        } else if indexPath.row == (advertDetail?.properties.count ?? 0) + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            cell.titleLabel.text = "İLAN AÇIKLAMASI"
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            cell.textLabel?.attributedText = advertDetail?.text.htmlToAttributedString
            cell.textLabel?.numberOfLines = .zero
            return cell
        }
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 360
        }else if indexPath.row <= advertDetail?.properties.count ?? 0 {
            return 50
        }else if indexPath.row == (advertDetail?.properties.count ?? 0) + 1 {
            return 40
        }else{
            return 400
        }
    }
}


