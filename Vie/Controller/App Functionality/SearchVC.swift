//
//  SearchVC.swift
//  Vie
//
//  Created by user137691 on 1/3/19.
//  Copyright © 2019 user137691. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON
import  IQKeyboardManager
class SearchVC: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var playGrounds:[PlayGround]=[]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.showsCancelButton=true
    }
    override func viewWillAppear(_ animated: Bool) {
     
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden=false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playGrounds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //playGrounds[0].IsSupportsReservations=true
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPlayGroundDetailesVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="goToPlayGroundDetailesVC"){
            let destinationVC=segue.destination as! PlayGroundDetailsVC
            let indexPath=collectionView.indexPathsForSelectedItems?.first
            destinationVC.playGroundobj=playGrounds[(indexPath?.row)!]
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
        var userID = -1
        if(HelperMethods.IsKeyPresentInUserDefaults(key: "UserID"))
        {
            userID=UserDefaults.standard.integer(forKey: "UserID")
        }
        PlayGround.GetPlayGroundsData(userID: userID, searchKey: searchBar.text ?? "") { (playGroundArray) in
            self.playGrounds=playGroundArray
            self.collectionView.reloadData()
        }
    }
 
}
