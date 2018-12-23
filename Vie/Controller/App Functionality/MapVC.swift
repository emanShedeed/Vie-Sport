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
import CoreLocation
class MapVC: UIViewController ,GMSMapViewDelegate,CLLocationManagerDelegate{

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var infoWindowView: UIView!
    //TODO: Declare instance variables here
    var userLocation:CLLocation?
    
    //TODO: Declare instance variables here
    let locationManager=CLLocationManager()
    var playGrounds:[PlayGround]=[]
    var markerDict: [Int: GMSMarker] = [:]
    var  selectedMarker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     
        self.navigationController?.navigationBar.topItem?.title = ""
        ///////////
        infoWindowView.isHidden=true
       //let camera=GMSCameraPosition.camera(withLatitude: 23.8859, longitude: 45.0792, zoom: 6.0)
       //mapView.camera=camera
        mapView.delegate=self
        self.mapView.bringSubviewToFront(infoWindowView)
        var userID = -1
        if(IsKeyPresentInUserDefaults(key: "UserID"))
        {
            userID=UserDefaults.standard.integer(forKey: "UserID")
        }
        PlayGround.GetPlayGroundsData(userID: userID) { (playGroundArray) in
            self.playGrounds=playGroundArray
            self.DisplayPlayGroundData(playGrounds: self.playGrounds)
            self.collectionView.reloadData()
            self.locationManager.startUpdatingLocation()
        }

        //TODO: Register your MessageCell.xib file here:
        collectionView.register(UINib(nibName: "PlayGroundInfoWindow", bundle: nil), forCellWithReuseIdentifier: "PlayGroundInfoWindow")
        
        //TODO:Set up the location manager here.
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        
    }
    func IsKeyPresentInUserDefaults(key:String)->Bool{
        return UserDefaults.standard.object(forKey: key) != nil
    }    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         userLocation = locations[locations.count-1]
        
        if let l=userLocation
        {
            if(l.horizontalAccuracy>0)
            {
                locationManager.stopUpdatingLocation()
                locationManager.delegate=nil
                print("latitude=\(l.coordinate.latitude),longtiude=\(l.coordinate.longitude)")
                let smallestDistance = PlayGround.GetDistance(playGrounds: playGrounds, userLocation: l)
                //save user location in user defaults
                let lat = l.coordinate.latitude
                let lon = l.coordinate.longitude
                let dect:[String:Double]=["lat":lat,"long":lon]
                UserDefaults.standard.set(dect, forKey: "userLocation")

                print("distance=\(String(describing: smallestDistance))")
                let camera=GMSCameraPosition.camera(withLatitude: l.coordinate.longitude, longitude: l.coordinate.longitude, zoom: 6.0)
                mapView.camera=camera
                if (smallestDistance != nil) ? smallestDistance! > 100000.0 :false{
                    let alert = UIAlertController(title: "", message: "لا توجد ملاعب قريبه منك هل تريد اضافة ملعب؟", preferredStyle: .alert)
                    let cancelAction=UIAlertAction(title: "لا", style: .cancel, handler: nil)
                    let Okaction=UIAlertAction(title: "نعم", style: .default) { (UIAlertAction) in
                    }
                    alert.addAction(Okaction)
                    alert.addAction(cancelAction)
                    self.present(alert,animated: true,completion: nil)
                }
            }
        }
        
    }
    
    

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.infoWindowView.isHidden=false
        /*let indexPath=IndexPath(row: playGrounds.firstIndex(where: { (obj) -> Bool in
            return (obj.PlayGroundName==marker.title)
         })!, section: 1)*/
        if let row=markerDict.someKey(forValue: marker){
            collectionView.scrollToItem(at: IndexPath(row: row, section: 0), at: .right, animated: false)
            selectedMarker.map=nil
            let camera=GMSCameraPosition.camera(withLatitude:marker.position.latitude, longitude: marker.position.longitude, zoom: 6.0)
            mapView.camera=camera
        }
        
        return true
    }
   
    func DisplayPlayGroundData(playGrounds:[PlayGround]){
       // DispatchQueue.main.async {
            
            for (index,playGround )in playGrounds.enumerated() {
                let playGround_marker = GMSMarker()
                playGround_marker.position = CLLocationCoordinate2D(latitude:Double(playGround.Lat)!, longitude:Double(playGround.Lng)!)
                playGround_marker.title = playGround.PlayGroundName
                playGround_marker.snippet = playGround.PlayGroundTypeName
                playGround_marker.map = self.mapView
                playGround_marker.userData=playGround
                self.markerDict[index] = playGround_marker
           // }
        }
    }
    
}
extension MapVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playGrounds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "PlayGroundInfoWindow", for: indexPath) as! PlayGroundInfoWindowModel
        let playGroundObj=playGrounds[indexPath.row]
        if  let url = URL(string: playGrounds[indexPath.row].ImagesLocation[0]){
            if let data = try? Data(contentsOf: url) {//make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                cell.ImageView.image=UIImage(data: data)
            }
        }
        cell.playGroundNameLabel.text=playGroundObj.PlayGroundName
        cell.playGroundTypeAndDimensionsLabel.text=playGroundObj.PlayGroundTypeName + "-" + playGroundObj.DimensionName
        cell.playGrounOnlineReservation.text=playGroundObj.IsSupportsReservations ? "يدعم الحجز الألكتروني" :"يتوفر الحجز الألكتروني قريبا"
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visiblecells=collectionView.visibleCells
        if let firstcell=visiblecells.first{
            if let indexpath=collectionView.indexPath(for: firstcell ){
                setSelectedMark(indexPath: indexpath)
            }
        }
    }
    func setSelectedMark(indexPath:IndexPath)
    {
        selectedMarker.map=nil
        selectedMarker=GMSMarker()
        selectedMarker.icon=UIImage(named: "markerIcon")
        let position=(Lat:Double((markerDict[indexPath.row]!.position.latitude)),Lng: Double(markerDict[indexPath.row]!.position.longitude))
        selectedMarker.position = CLLocationCoordinate2D(latitude:position.0, longitude:position.1)
        selectedMarker.map = self.mapView
        let camera=GMSCameraPosition.camera(withLatitude: position.0, longitude: position.1, zoom: 6.0)
        mapView.camera=camera
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: infoWindowView.frame.width, height: infoWindowView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPlayGroundDetailsVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="goToPlayGroundDetailsVC"){
            
            let destinationVC=segue.destination as! PlayGroundDetailsVC
            let indexPath=collectionView.indexPathsForSelectedItems?.first
            destinationVC.playGroundobj=playGrounds[(indexPath?.row)!]
        }
    }
}

