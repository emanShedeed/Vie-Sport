//
//  MapCollectionViewVC.swift
//  Vie
//
//  Created by user137691 on 11/19/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import GoogleMaps
class MapCollectionViewVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
  
    @IBOutlet weak var collectionView: UICollectionView!
    var playGrounds:[PlayGround]=[]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        PlayGround.GetPlayGroundsData { (playGroundArray) in
            self.playGrounds=playGroundArray
            self.collectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playGrounds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        playGrounds[0].IsSupportsReservations=true
        var playGroundObj=playGrounds[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCell
        if let url=URL(string: playGroundObj.ImagesLocation[0]){
            if let data=try? Data(contentsOf: url){
                cell.playGroundImageView.image=UIImage(data: data)
            }
        }
        cell.playGroundNameLabel.text=playGroundObj.PlayGroundName + " - " + playGroundObj.DimensionName
        var playGroundLocation=playGrounds[indexPath.row].CityName
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
