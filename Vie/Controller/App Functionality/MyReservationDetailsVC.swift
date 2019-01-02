//
//  MyReservationDetailsVC.swift
//  Vie
//
//  Created by user137691 on 1/1/19.
//  Copyright © 2019 user137691. All rights reserved.
//

import UIKit
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
  //  @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var contentViewWidth: NSLayoutConstraint!
    // @IBOutlet weak var similarPlayGroundView: UIView!
    @IBOutlet weak var ReservationView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden=false
        self.navigationItem.title="تفاصيل الحجز"
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden=false
        //Add tapgesture to reervation view
        //add tap gesture
        let tapGesture=UITapGestureRecognizer(target: self, action:#selector(ServicesViewTapped))
        servicesView.addGestureRecognizer(tapGesture)
        let tap=UITapGestureRecognizer(target: self, action: #selector(AddPlayGroundReservation))
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
    func InitScrollView(){
        //configure scroll view and page control
        var images=playGroundReservationObj.0.ImagesLocation
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
        contentViewWidth.constant=scrollView.contentSize.width
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
        InitScrollView()
//
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
    @objc func AddPlayGroundReservation(){
        performSegue(withIdentifier: "goToPlayGroundReservationVC", sender: self)
    }
}
