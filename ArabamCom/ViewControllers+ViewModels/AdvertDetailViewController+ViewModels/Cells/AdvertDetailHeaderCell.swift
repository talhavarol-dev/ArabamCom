//
//  AdvertDetailHeaderCell.swift
//  ArabamCom
//
//  Created by Muhammet  on 19.04.2023.
//

import UIKit
import Kingfisher
class AdvertDetailHeaderCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var location: Location? {
        didSet {
            locationLabel.text = "\(location?.cityName ?? "-"), \(location?.townName ?? "-")"
        }
    }
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
