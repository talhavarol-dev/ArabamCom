//
//  TableViewCell.swift
//  ArabamCom
//
//  Created by Muhammet  on 20.04.2023.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        largeContentTitle = "İlan Açıklaması"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
