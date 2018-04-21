//
//  ProductTableViewCell.swift
//  RafaelSoares
//
//  Created by user138685 on 4/19/18.
//  Copyright © 2018 fiap. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
