//
//  PlayGroundLocationVC.swift
//  Vie
//
//  Created by user137691 on 1/3/19.
//  Copyright © 2019 user137691. All rights reserved.
//

import UIKit
import GoogleMaps
class AddingPlayGround1_LocationVC: UIViewController,GMSMapViewDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    var Marker:GMSMarker?
    var playGroundObj = PlayGround()
    var playGroundInfoDict = [String:Any]()
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
        //let camera=GMSCameraPosition.camera(withLatitude: position.target.latitude, longitude:position.target.longitude , zoom: 6.0)
       // mapView.camera=camera
    }
    
    @IBAction func NextButtonPressed(_ sender: Any) {
        playGroundObj.Lat=String((Marker?.position.latitude)!)
        playGroundObj.Lng=String((Marker?.position.longitude)!)
        playGroundInfoDict["Lat"] = [String((Marker?.position.latitude)!)]
        playGroundInfoDict["Lng"] = [String((Marker?.position.longitude)!)]
        getAddress { (country, city, district) in
            self.playGroundInfoDict["DistrictNameByGM"]=district
            self.playGroundInfoDict["CityNameByGM"]=city
            self.performSegue(withIdentifier: "goToAddingPlayGround_2 VC", sender: self)
        }
      
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToAddingPlayGround_2 VC"){
            let destinationVC = segue.destination as! AddingPlayGround2_InfoVC
            destinationVC.playGroundObj = playGroundObj
            destinationVC.playGroundInfoDict = playGroundInfoDict
        }
    }
    func getAddress(currentAdd : @escaping ( _ country : String?, _ city :String?, _ district:String?)->Void){
        let geo=CLGeocoder()
        let local=Locale(identifier: "ar_sa")
        let location=CLLocation(latitude: (Marker?.position.latitude)!, longitude: (Marker?.position.longitude)!)
        geo.reverseGeocodeLocation(location, preferredLocale: local) { placeMarkers, error in
            if let error2 = error{
                print(error2)
            }else {
                 let country = placeMarkers?.first?.country
                let city=placeMarkers?.first?.locality
                let district=placeMarkers?.first?.subLocality
                currentAdd(country,city,district)
            
        }
    }
}
}
