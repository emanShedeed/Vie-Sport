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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var infoWindowView: UIView!
    
    
    var playGrounds:[PlayGround]=[]
    var markerDict: [Int: GMSMarker] = [:]
    var  selectedMarker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        infoWindowView.isHidden=true
        let camera=GMSCameraPosition.camera(withLatitude: 23.8859, longitude: 45.0792, zoom: 6.0)
        mapView.camera=camera
        mapView.delegate=self
      self.mapView.bringSubviewToFront(infoWindowView)
        PlayGround.GetPlayGroundsData { (playGroundArray) in
            self.playGrounds=playGroundArray
            self.DisplayPlayGroundData(playGrounds: self.playGrounds)
            self.collectionView.reloadData()
        }
        //TODO: Register your MessageCell.xib file here:
        collectionView.register(UINib(nibName: "PlayGroundInfoWindow", bundle: nil), forCellWithReuseIdentifier: "PlayGroundInfoWindow")
        //
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.infoWindowView.isHidden=false
        /*let indexPath=IndexPath(row: playGrounds.firstIndex(where: { (obj) -> Bool in
            return (obj.PlayGroundName==marker.title)
         })!, section: 1)*/
        if let row=markerDict.someKey(forValue: marker){
            collectionView.scrollToItem(at: IndexPath(row: row, section: 0), at: .right, animated: false)
            selectedMarker.map=nil
        }
        
        return true
    }
   
    func DisplayPlayGroundData(playGrounds:[PlayGround]){
        DispatchQueue.main.async {
            
            for (index,playGround )in playGrounds.enumerated() {
                let playGround_marker = GMSMarker()
                playGround_marker.position = CLLocationCoordinate2D(latitude:Double(playGround.Lat)!, longitude:Double(playGround.Lng)!)
                playGround_marker.title = playGround.PlayGroundName
                playGround_marker.snippet = playGround.PlayGroundTypeName
                playGround_marker.map = self.mapView
                playGround_marker.userData=playGround
                self.markerDict[index] = playGround_marker
            }
        }
    }

}
extension MapVC: UICollectionViewDataSource,UICollectionViewDelegate {
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
        cell.playGrounOnlineReservation.text=playGroundObj.IsSupportsReservations ? "يدعم الحجز الألكترونس" :"يتوفر الحجز الألكتروني قريبا"
        return cell
    }
  
    /*func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMarker.map=nil
        selectedMarker=GMSMarker()
        selectedMarker.icon=UIImage(named: "markerIcon")
        let position=(Lat:Double((markerDict[indexPath.row]!.position.latitude)),Lng: Double(markerDict[indexPath.row]!.position.longitude))
        selectedMarker.position = CLLocationCoordinate2D(latitude:position.0, longitude:position.1)
        selectedMarker.map = self.mapView
        let camera=GMSCameraPosition.camera(withLatitude: position.0, longitude: position.1, zoom: 6.0)
        mapView.camera=camera
        
    }*/
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
        mapView.camera=camera    }
}
