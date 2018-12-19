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
    var playGroundObj=PlayGround()
    var date=String()
    var periodObj=Period()
    
    @IBOutlet weak var playGrounName: UILabel!
    @IBOutlet weak var periodDate: UILabel!
    @IBOutlet weak var periodTime: UILabel!
    @IBOutlet weak var periodMl3byPrice: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        playGrounName.text=playGroundObj.PlayGroundName
        periodDate.text=date
        periodTime.text=periodObj.StartTime + " - " + periodObj.EndTime
        periodMl3byPrice.text=String(periodObj.Ml3byPrice)+" ريال"
        let position=(Lat:Double(playGroundObj.Lat)!,Lng: Double(playGroundObj.Lng)!)
        let camera=GMSCameraPosition.camera(withLatitude: position.0 , longitude: position.1 , zoom: 9.0)
        mapView.camera=camera
        let marker=GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude:position.0, longitude:position.1)
        marker.map = self.mapView
    }
    

    

}
