//
//  Map VC.swift
//  Vie
//
//  Created by user137691 on 11/11/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import SwiftyJSON
import GoogleMaps
class MapVC: UIViewController {
    
   // let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: 23.8859, longitude: 45.0792, zoom: 6.0))
    var playGrounds:[PlayGround]=[]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        PlayGround.GetPlayGroundsData { (playGroundArray) in
            self.playGrounds=playGroundArray
            self.DisplayPlayGroundData(playGrounds: self.playGrounds)
        }
        
    }
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        view = mapView
        
       /* // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
         marker.map = mapView*/
    }
    func DisplayPlayGroundData(playGrounds:[PlayGround]){
        
        for playGround in playGrounds {
            let playGround_marker = GMSMarker()
            playGround_marker.position = CLLocationCoordinate2D(latitude:Double(playGround.Lat)!, longitude:Double(playGround.Lng)!)
            playGround_marker.title = playGround.PlayGroundName
            playGround_marker.snippet = playGround.PlayGroundTypeName
            playGround_marker.map = mapView
        }
    }
   
    
}
