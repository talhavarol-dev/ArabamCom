//
//  HeaderTableViewCell.swift
//  ArabamCom
//
//  Created by Muhammet  on 20.04.2023.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photoArray: [String]? {
          didSet {
              collectionView.reloadData()
          }
      }
    var location: Location? {
        didSet {
            locationLabel.text = "\(location?.cityName ?? "-"), \(location?.townName ?? "-")"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "HeaderCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "HeaderCollectionViewCell")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
extension HeaderTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionViewCell", for: indexPath) as? HeaderCollectionViewCell,
                 let photoUrl = photoArray?[indexPath.row] else {
               return UICollectionViewCell()
           }
           cell.setImage(with: photoUrl)
           return cell
       }
}
