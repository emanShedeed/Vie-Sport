//
//  PlayGroundInfoWindow.swift
//  Vie
//
//  Created by user137691 on 11/13/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit

class PlayGroundInfoWindowModel: UICollectionViewCell {

    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var playGroundNameLabel: UILabel!
    
    @IBOutlet weak var playGroundTypeAndDimensionsLabel: UILabel!
    
    @IBOutlet weak var playGrounOnlineReservation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
