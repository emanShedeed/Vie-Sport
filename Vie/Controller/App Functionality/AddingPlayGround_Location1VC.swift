//
//  PlayGroundLocationVC.swift
//  Vie
//
//  Created by user137691 on 1/3/19.
//  Copyright © 2019 user137691. All rights reserved.
//

import UIKit
import GoogleMaps
class AddingPlayGround_Location1VC: UIViewController,GMSMapViewDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    var Marker:GMSMarker?
    var playGroundObj = PlayGround()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        InitMap()
        self.navigationItem.title="حدد موقع الملعب"
    }

    func InitMap(){
        if let userLocation=UserDefaults.standard.value(forKey: "userLocation") as? [String:Double]{
            //Marker.icon=UIImage(named: "markerIcon")
            let position=(Lat:userLocation["lat"]!,Lng:userLocation["long"]!)
            Marker = GMSMarker(position: CLLocationCoordinate2D(latitude:position.0, longitude:position.1))
            Marker?.map = self.mapView
            let camera=GMSCameraPosition.camera(withLatitude: position.0, longitude: position.1 , zoom: 6.0)
            mapView.camera=camera
            
        }
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        Marker?.map=nil
        Marker=nil
        Marker=GMSMarker(position: position.target)
        Marker?.map=mapView
       let camera=GMSCameraPosition.camera(withLatitude: position.target.latitude, longitude:position.target.longitude , zoom: 6.0)
        mapView.camera=camera
    }
    
    @IBAction func NextButtonPressed(_ sender: Any) {
        playGroundObj.Lat=String((Marker?.position.latitude)!)
        playGroundObj.Lng=String((Marker?.position.longitude)!)
        performSegue(withIdentifier: "goToAddingPlayGround_2 VC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="goToAddingPlayGround_2 VC"){
            let destinationVC=segue.destination as! AddingPlayGround_2VC
            destinationVC.playGroundObj=playGroundObj
        }
    }
}
