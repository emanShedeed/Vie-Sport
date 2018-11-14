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
class MapVC: UIViewController ,GMSMapViewDelegate{

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var containerView: UIView!
    
    var playGrounds:[PlayGround]=[]
    var markerDict: [Int: GMSMarker] = [:]
    private var infoWindow=PlayGroundInfoWindowModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        containerView.isHidden=true
        let camera=GMSCameraPosition.camera(withLatitude: 23.8859, longitude: 45.0792, zoom: 6.0)
        mapView.camera=camera
        mapView.delegate=self
      self.mapView.bringSubviewToFront(containerView)
        PlayGround.GetPlayGroundsData { (playGroundArray) in
            self.playGrounds=playGroundArray
            self.DisplayPlayGroundData(playGrounds: self.playGrounds)
        }
        
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.containerView.isHidden=false
        return true
    }
   
    func DisplayPlayGroundData(playGrounds:[PlayGround]){
        DispatchQueue.main.async {
            
            for playGround in playGrounds {
                let playGround_marker = GMSMarker()
                playGround_marker.position = CLLocationCoordinate2D(latitude:Double(playGround.Lat)!, longitude:Double(playGround.Lng)!)
                playGround_marker.title = playGround.PlayGroundName
                playGround_marker.snippet = playGround.PlayGroundTypeName
                playGround_marker.map = self.mapView
                playGround_marker.userData=playGround
                self.markerDict[playGround.PlayGroundID] = playGround_marker
            }
        }
    }

}
