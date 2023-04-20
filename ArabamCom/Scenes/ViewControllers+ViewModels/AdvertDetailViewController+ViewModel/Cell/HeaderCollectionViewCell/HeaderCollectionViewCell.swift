//
//  HeaderCollectionViewCell.swift
//  ArabamCom
//
//  Created by Muhammet  on 20.04.2023.
//

import UIKit
import Kingfisher

class HeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setImage(with url: String) {
        imageView.kf.setImage(with: URL(string: url.replacingOccurrences(of: "{0}", with: "800x600")))
        print(url)
       }

}
