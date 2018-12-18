//
//  ReservationInfoVC.swift
//  Vie
//
//  Created by user137691 on 12/18/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import GoogleMaps
class ReservationInfoVC: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let camera=GMSCameraPosition.camera(withLatitude: 30.0444 , longitude: 31.2357 , zoom: 6.0)
        mapView.camera=camera
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
