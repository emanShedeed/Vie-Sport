//
//  PlayGroundDetailsVC.swift
//  Vie
//
//  Created by user137691 on 11/19/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import GoogleMaps
import Kingfisher
import SwiftyJSON
class PlayGroundDetailsVC: UIViewController,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var playGroundobj=PlayGround()
    var similarPlayGrounds=[PlayGround]()
    var frame=CGRect(x: 0, y: 0, width: 0, height: 0)
    var Share = UIBarButtonItem()
    var FavoriteButtonOn = UIBarButtonItem()
    var FavoriteButtonOff = UIBarButtonItem()
    // MAARK : - @IBOutlets
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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var contentViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var similarPlayGroundView: UIView!
    @IBOutlet weak var ReservationView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Add tapgesture to reervation view
        //add tap gesture
        let tapGesture=UITapGestureRecognizer(target: self, action:#selector(ServicesViewTapped))
        servicesView.addGestureRecognizer(tapGesture)
        let tap=UITapGestureRecognizer(target: self, action: #selector(AddPlayGroundReservation))
        ReservationView.addGestureRecognizer(tap)
        // display reservation view if playgroun has online reservation
        if playGroundobj.IsSupportsReservations == false{
            ReservationView.isHidden=true
        }
        collectionView.dataSource=self
        collectionView.delegate=self
        self.tabBarController?.tabBar.isHidden=true
        InitPlayGroundData()
        InitScrollView()
        InitNavBar()
        InitMap()
        GetSimilarPlayGrounds()
    }
    //MARK :- Init View
    func InitNavBar()
    {
        //add right navigation bar buttons
         Share = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(shareButtonPressed))
         FavoriteButtonOn = UIBarButtonItem(barButtonSystemItem: .cancel , target: self, action: #selector(AddORRemoveFromFavoritesButtonPressed))
         FavoriteButtonOff = UIBarButtonItem(barButtonSystemItem: .compose , target: self, action: #selector(AddORRemoveFromFavoritesButtonPressed))
        if(playGroundobj.IsFavorite==true)
        {
            navigationItem.rightBarButtonItems = [Share, FavoriteButtonOn]
        }
        else{
            navigationItem.rightBarButtonItems=[Share,FavoriteButtonOff]
        }
        
        //set navigation title
        navigationItem.title=playGroundobj.PlayGroundName
        
    }
    func InitScrollView(){
        //configure scroll view and page control
        var images=playGroundobj.ImagesLocation
        pageControl.numberOfPages=images.count
        for index in 0..<images.count
        {
            frame.origin.x=scrollView.frame.size.width*CGFloat(index)
            frame.size=scrollView.frame.size
            let imageView=UIImageView(frame:frame)
            if let url=URL(string: images[index]){
                imageView.kf.setImage(with: url)
            }
            self.scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize=CGSize(width: (scrollView.frame.size.width * CGFloat(images.count)), height: scrollView.frame.size.height)
        contentViewWidth.constant=scrollView.contentSize.width    }
    func InitPlayGroundData(){
        playGroundName.text=playGroundobj.PlayGroundName
        playGroundCity.text=playGroundobj.CityName
        playGroundTypeAndDimension.text=playGroundobj.PlayGroundTypeName + "\n" + playGroundobj.DimensionName
        let servicesImgesCount=playGroundobj.Services.count
        ServicesImagesViews.sort{$0.tag < $1.tag}
        remainingServicesImagesCountLabel.isHidden=(servicesImgesCount-4)<0
        remainingServicesImagesCountLabel.text=String(servicesImgesCount-4) + "+"
        var serviceObj:PlaygroundServices
        let count = servicesImgesCount > 4 ? 4 :servicesImgesCount
        for index in 0..<count{
            serviceObj=playGroundobj.Services[index]
            ServicesImagesViews[index].isHidden=true
       
            if let url=URL(string: serviceObj.ActiveIcon){
                    ServicesImagesViews[index].isHidden=false
                    ServicesImagesViews[index].kf.setImage(with: url)
            }
        }
     
    }
    func InitMap(){
        let camera=GMSCameraPosition.camera(withLatitude:Double(playGroundobj.Lat)!, longitude: Double(playGroundobj.Lng)!, zoom: 10.0)
        mapView.camera=camera
        let marker=GMSMarker()
        marker.position=CLLocationCoordinate2D(latitude:Double(playGroundobj.Lat)!, longitude:Double(playGroundobj.Lng)!)
        marker.map=mapView
        
    }
    // Mark :- ScrollView delegate methods
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber=scrollView.contentOffset.x/scrollView.frame.size.width
        pageControl.currentPage=Int(pageNumber)
        
    }
    //Mark :- share button
    @objc func shareButtonPressed() {
        let text = "This is the text...."
        let image = UIImage(named: "playground")
      // let myWebsite = NSURL(string:"https://stackoverflow.com/users/4600136/mr-javed-multani?tab=profile")
        let shareAll = [text , image!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }
    @objc func AddORRemoveFromFavoritesButtonPressed(){
        if(IsKeyPresentInUserDefaults(key: "UserID"))
        {
            let userID=UserDefaults.standard.integer(forKey: "UserID")
            if(playGroundobj.IsFavorite == false)
            {
                if let request = APIClient.AddPlayGroundToFavorites(userID:userID, PlayGroundID:playGroundobj.PlayGroundID){
                    APIClient().jsonRequest(request: request, CompletionHandler: { (JsonValue: JSON?,statusCode:Int,responseMessageStatus:ResponseMessageStatusEnum?,userMessage:String?) -> (Void) in
                        
                        if let  data = JsonValue{
                            let status=data["Status"]
                            if (status=="Success"){
                                print("successfuly AddedToFavorities")
                                self.navigationItem.setLeftBarButtonItems([self.Share, self.FavoriteButtonOn], animated: false)
                                
                            }
                        }
                        
                    })
                }
            }
            else{
                
                if let request = APIClient.DeletePlayGroundFromFavorites(userID:userID, PlayGroundID:playGroundobj.PlayGroundID){
                    APIClient().jsonRequest(request: request, CompletionHandler: { (JsonValue: JSON?,statusCode:Int,responseMessageStatus:ResponseMessageStatusEnum?,userMessage:String?) -> (Void) in
                        if let  data = JsonValue{
                            let status=data["Status"]
                            if (status=="Success"){
                                print("successfuly Removed from Favorities")
                                self.navigationItem.setLeftBarButtonItems([self.Share, self.FavoriteButtonOff], animated: false)  
                            }
                        }
                        
                    })
                }
            }
        }
        else{
            let alert=UIAlertController(title: "", message: "من فضلك قم بالتسجيل أولا", preferredStyle: .alert)
            let action=UIAlertAction(title: "موافق", style: .default) { (OKaction) in
                self.performSegue(withIdentifier: "goToSignUpVC", sender: self)
            }
            alert.addAction(action)
            self.present(alert, animated: true)
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
            destinationVC.playGroundServices=playGroundobj.Services
        }
        else if(segue.identifier=="goToPlayGroundReservationVC"){
            
            let destinationVC=segue.destination as! PlayGroundReservationVC
            //let indexPath=collectionView.indexPathsForSelectedItems?.first
            destinationVC.playGroundobj=playGroundobj
        }
    }
    func IsKeyPresentInUserDefaults(key:String)->Bool{
        return UserDefaults.standard.object(forKey: key) != nil
    }
    func GetSimilarPlayGrounds(){
        var userID=""
        if(IsKeyPresentInUserDefaults(key: "UserID"))
        {
         userID=String(UserDefaults.standard.integer(forKey: "UserID"))
        }
        PlayGround.GetSimilarPlayGroundsData(playGroundID: String(playGroundobj.PlayGroundID), userID: userID) { (SimilarArray) in
            self.similarPlayGrounds=SimilarArray
            self.collectionView.reloadData()
        }
    }
 /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: similarPlayGroundView.frame.width, height: similarPlayGroundView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
     }*/
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
       // print(collectionView)
        print(collectionView.bounds.width,collectionView.bounds.height)
        return CGSize(width: collectionView.bounds.width, height: similarPlayGroundView.frame.height)
        
    }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarPlayGrounds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var similarPlayGroundObj=PlayGround()
        similarPlayGroundObj=similarPlayGrounds[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarPlayGroundCell", for: indexPath) as! SimilarPlayGroundCell
        cell.PlayGroundCity.text=similarPlayGroundObj.CityName
        cell.PlayGroundTypeAndDimensions.text=similarPlayGroundObj.PlayGroundTypeName + " - " + similarPlayGroundObj.DimensionName
        if(similarPlayGroundObj.ImagesLocation.count>1)
        {
            if let url=URL(string: similarPlayGroundObj.ImagesLocation[0]){
                cell.playGroundImageView.kf.setImage(with: url)
            }
        }
        return cell
    }
    @objc func AddPlayGroundReservation(){
     performSegue(withIdentifier: "goToPlayGroundReservationVC", sender: self)
    }
  
}
