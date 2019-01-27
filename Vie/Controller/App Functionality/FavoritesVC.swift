//
//  FavoritesVC.swift
//  Vie
//
//  Created by user137691 on 12/31/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON
class FavoritesVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var favoritePlayGrounds=[PlayGround]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden=false
        self.navigationItem.title="المفضلة"
        
        if(HelperMethods.IsKeyPresentInUserDefaults(key: "AccessToken")){
            let accessToken=UserDefaults.standard.value(forKey: "AccessToken") as! String
        PlayGround.GetFavoritesPlayGround(accessToken:accessToken) { (playGroundArray) in
            self.favoritePlayGrounds=playGroundArray
            self.collectionView.reloadData()
        }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritePlayGrounds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //playGrounds[0].IsSupportsReservations=true
        var playGroundObj=favoritePlayGrounds[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCell
        if let url=URL(string: playGroundObj.ImagesLocation[0]){
            if let data=try? Data(contentsOf: url){
                cell.playGroundImageView.image=UIImage(data: data)
            }
        }
        cell.playGroundNameLabel.text=playGroundObj.PlayGroundName + " - " + playGroundObj.DimensionName
        var playGroundLocation=favoritePlayGrounds[indexPath.row].CityName
        if let userLocation=UserDefaults.standard.value(forKey: "userLocation") as? [String:Double]{
            let userCllocation=CLLocation(latitude: userLocation["lat"]!, longitude: userLocation["long"]!)
            if let distance=PlayGround.GetDistance(playGrounds: [playGroundObj], userLocation: userCllocation){
                let distanceInKM=distance/1000
                let distanceToNeraect2Digits=Double(round(distanceInKM*100)/100)
                playGroundLocation = playGroundLocation + " - " + String(distanceToNeraect2Digits) + " KM"
            }
        }
        cell.playGroundplaceLabel.text=playGroundLocation
        if playGroundObj.IsSupportsReservations{
            cell.playGroundReservationLabel.isHidden=false
        }
        else{cell.playGroundReservationLabel.isHidden=true}
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPlayGroundDetailesVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="goToPlayGroundDetailesVC"){
            let destinationVC=segue.destination as! PlayGroundDetailsVC
            let indexPath=collectionView.indexPathsForSelectedItems?.first
            destinationVC.playGroundobj=favoritePlayGrounds[(indexPath?.row)!]
        }
    }


}
