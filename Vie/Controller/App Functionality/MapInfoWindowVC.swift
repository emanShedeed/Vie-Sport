//
//  PlayGroundcollectionViewVC.swift
//  Vie
//
//  Created by user137691 on 11/13/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit

class MapInfoWindowVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    var playGrounds:[PlayGround]=[]
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        PlayGround.GetPlayGroundsData { (playGroundArray) in
            self.playGrounds=playGroundArray
            self.collectionView.reloadData()
        }
        //TODO: Register your MessageCell.xib file here:
        collectionView.register(UINib(nibName: "PlayGroundInfoWindow", bundle: nil), forCellWithReuseIdentifier: "PlayGroundInfoWindow")
        
       
        }
   
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
    
 
}
