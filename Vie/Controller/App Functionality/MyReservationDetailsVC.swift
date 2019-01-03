//
//  MyReservationDetailsVC.swift
//  Vie
//
//  Created by user137691 on 1/1/19.
//  Copyright © 2019 user137691. All rights reserved.
//

import UIKit
import SwiftyJSON
import GoogleMaps
class MyReservationDetailsVC: UIViewController,UITableViewDelegate {
    var playGroundReservationObj = (PlayGround(),Reservation())
    var isCurrenetReservation:Bool=true
    var frame=CGRect(x: 0, y: 0, width: 0, height: 0)
    // MAARK : - @IBOutlets
    //IBOUTlets reservation
    @IBOutlet weak var periodDate: UILabel!
    @IBOutlet weak var periodTime: UILabel!
    @IBOutlet weak var periodMl3byPrice: UILabel!
    /////////
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var playGroundName: UILabel!
    @IBOutlet weak var playGroundTypeAndDimension: UILabel!
    @IBOutlet weak var playGroundCity: UILabel!
    @IBOutlet var ServicesImagesViews: [UIImageView]!
    @IBOutlet weak var remainingServicesImagesCountLabel: UILabel!
    @IBOutlet weak var servicesView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var contentView: UIView!
   @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    // @IBOutlet weak var similarPlayGroundView: UIView!
    @IBOutlet weak var ReservationView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationItem.title="تفاصيل الحجز"
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden=false
        //Add tapgesture to reervation view
        //add tap gesture
        let tapGesture=UITapGestureRecognizer(target: self, action:#selector(ServicesViewTapped))
        servicesView.addGestureRecognizer(tapGesture)
        let tap=UITapGestureRecognizer(target: self, action: #selector(CancelPlayGroundReservation))
        ReservationView.addGestureRecognizer(tap)
        InitPlayGroundData()
        InitReservationData()
      //  InitScrollView()
        InitMap()
    }
    func InitPlayGroundData(){
        playGroundName.text=playGroundReservationObj.0.PlayGroundName
        playGroundCity.text=playGroundReservationObj.0.CityName
        playGroundTypeAndDimension.text=playGroundReservationObj.0.PlayGroundTypeName + "\n" + playGroundReservationObj.0.DimensionName
        let servicesImgesCount=playGroundReservationObj.0.Services.count
        ServicesImagesViews.sort{$0.tag < $1.tag}
        remainingServicesImagesCountLabel.isHidden=(servicesImgesCount-4)<0
        remainingServicesImagesCountLabel.text=String(servicesImgesCount-4) + "+"
        var serviceObj:PlaygroundServices
        let count = servicesImgesCount > 4 ? 4 :servicesImgesCount
        for index in 0..<count{
            serviceObj=playGroundReservationObj.0.Services[index]
            ServicesImagesViews[index].isHidden=true
            
            if let url=URL(string: serviceObj.ActiveIcon){
                ServicesImagesViews[index].isHidden=false
                ServicesImagesViews[index].kf.setImage(with: url)
            }
        }
        
    }
    func InitReservationData(){
        periodDate.text=playGroundReservationObj.1.Date
        periodTime.text=playGroundReservationObj.1.StartTime + " - " + playGroundReservationObj.1.EndTime
        periodMl3byPrice.text=String(playGroundReservationObj.1.Price)+" ريال"
    }
   
    func InitMap(){
        let camera=GMSCameraPosition.camera(withLatitude:Double(playGroundReservationObj.0.Lat)!, longitude: Double(playGroundReservationObj.0.Lng)!, zoom: 10.0)
        mapView.camera=camera
        let marker=GMSMarker()
        marker.position=CLLocationCoordinate2D(latitude:Double(playGroundReservationObj.0.Lat)!, longitude:Double(playGroundReservationObj.0.Lng)!)
        marker.map=mapView
        
    }
    // Mark :- ScrollView delegate methods
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber=scrollView.contentOffset.x/scrollView.frame.size.width
        pageControl.currentPage=Int(pageNumber)
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        if(isCurrenetReservation==false){
            ReservationView.isHidden=true
        }
    }
    //Mark: tapGestture
    @objc func ServicesViewTapped(){
        performSegue(withIdentifier: "goToPlayGroundServices", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="goToPlayGroundServices")
        {
            let destinationVC=segue.destination as! PlayGroundServicesVC
            destinationVC.playGroundServices=playGroundReservationObj.0.Services
        }
    }
    @objc func CancelPlayGroundReservation(){
        if(HelperMethods.IsKeyPresentInUserDefaults(key: "AccessToken")){
            let accessToken=UserDefaults.standard.value(forKey: "AccessToken") as! String
            if let request=APIClient.CancelReservation(accessToken: accessToken, reservaionID: playGroundReservationObj.1.ReservationID){
                APIClient().jsonRequest(request: request) { (JsonValue:JSON?, statusCode:Int, responseMessageStatus:ResponseMessageStatusEnum?,userMessage:String?) -> (Void) in
                    if let  data = JsonValue{
                        let status=data["Status"]
                        if (status=="Success"){
                            print("successfuly cancel reservation")
                        }
                        else if(status=="Error"){
                            let alert=UIAlertController(title: "", message: data["Message"].stringValue, preferredStyle:.alert)
                            let action=UIAlertAction(title: "Ok", style: .default , handler: nil)
                            alert.addAction(action)
                            self.present(alert,animated: true,completion: nil)
                        }
                    }
                }
            }
        }
    }
}
extension MyReservationDetailsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return playGroundReservationObj.0.ImagesLocation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        if let url=URL(string: playGroundReservationObj.0.ImagesLocation[indexPath.row]){
           cell.imageView.kf.setImage(with: url)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(collectionView.bounds.size.width,CGFloat(233))
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(233))
    }
}
