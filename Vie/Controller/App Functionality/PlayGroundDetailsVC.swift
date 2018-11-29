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
class PlayGroundDetailsVC: UIViewController,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate {

    
    var playGroundobj=PlayGround()
    var frame=CGRect(x: 0, y: 0, width: 0, height: 0)
    
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
    
    @IBOutlet weak var pageControlview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        InitView()
        //
        //self.scrollView.bringSubviewToFront(pageView)
        //hide navigtion back button text
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back1")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back1")
        
        //add right navigation bar buttons
       let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(shareButtonPressed(_:)))
        let play = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(shareButtonPressed(_:)))
        navigationItem.rightBarButtonItems = [add, play]
        
        //set navigation title
        navigationItem.title=playGroundobj.PlayGroundName
        //add tap gesture
        let tapGesture=UITapGestureRecognizer(target: self, action:#selector(ServicesViewTapped))
        servicesView.addGestureRecognizer(tapGesture)
        
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
            self.pageControlview.addSubview(imageView)
        }
        
        scrollView.contentSize=CGSize(width: (scrollView.frame.size.width * CGFloat(images.count)), height: scrollView.frame.size.height)
       // scrollView.bringSubviewToFront(pageControlview)
    }
    // Mark :- ScrollView delegate methods
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber=scrollView.contentOffset.x/scrollView.frame.size.width
        pageControl.currentPage=Int(pageNumber)
        
    }
    //MARK :- Init View
    func InitView(){
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
        let camera=GMSCameraPosition.camera(withLatitude:Double(playGroundobj.Lat)!, longitude: Double(playGroundobj.Lng)!, zoom: 10.0)
        mapView.camera=camera
        
    }
    //Mark :- share button
    @objc func shareButtonPressed(_ sender: Any) {
        let text = "This is the text...."
        let image = UIImage(named: "playground")
      // let myWebsite = NSURL(string:"https://stackoverflow.com/users/4600136/mr-javed-multani?tab=profile")
        let shareAll = [text , image!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
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
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarPlayGroundCell", for: indexPath)
        return cell
    }
    
}
