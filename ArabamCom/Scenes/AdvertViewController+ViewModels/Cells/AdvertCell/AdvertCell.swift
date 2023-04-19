//
//  AdvertCell.swift
//  ArabamCom
//
//  Created by Muhammet  on 16.04.2023.
//

import UIKit
import Kingfisher

final class AdvertCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var advertImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var location: Location? {
        didSet{
            locationLabel.text = "\(self.location?.cityName ?? "-"), \(location?.townName ?? "-")"
        }
    }
    func advertCellConfigure(model: Advert) {
        titleLabel.text = model.title
        location = model.location
        priceLabel.text = model.priceFormatted
        advertImageView.kf.setImage(with: URL(string: model.photo.replacingOccurrences(of: "{0}", with: "240x180")))
        print(model.photo)
    }
    
    var price: NSNumber? {
        didSet {
            guard let price = price else { return }
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "tr_TR")
            priceLabel.text = formatter.string(from: price)
        }
    }
}



