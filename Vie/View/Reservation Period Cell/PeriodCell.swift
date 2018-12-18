//
//  PeriodCell.swift
//  Vie
//
//  Created by user137691 on 12/10/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit

class PeriodCell: UITableViewCell {
    
    @IBOutlet weak var periodTimeLabel:UILabel!
    @IBOutlet weak var periodPriceLabel:UILabel!
    @IBOutlet weak var periodValidationLabel:UILabel!
    @IBOutlet weak var view:UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        view.frame=view.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10))
    }
 
}
