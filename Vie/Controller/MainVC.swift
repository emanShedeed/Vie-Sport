//
//  ViewController.swift
//  Vie
//
//  Created by user137691 on 10/9/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit

class MainVC: UIViewController , UIScrollViewDelegate{
    
    //MARK: - IBoutlet Defination
    @IBOutlet weak var pageControl:UIPageControl!
    @IBOutlet weak var scrollView:UIScrollView!
    //MARK :- Declare Constants
    var images:[String]=["0","1","2"]
    var frame=CGRect(x: 0, y: 0, width: 0, height: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pageControl.numberOfPages=images.count
        for index in 0..<images.count
        {
            frame.origin.x=scrollView.frame.size.width*CGFloat(index)
            frame.size=scrollView.frame.size
            let imageView=UIImageView(frame:frame)
            imageView.image=UIImage(named: images[index])
            self.scrollView.addSubview(imageView)
        }
        scrollView.contentSize=CGSize(width: (scrollView.frame.size.width * CGFloat(images.count)), height: scrollView.frame.size.height)
    }
    // Mark :- ScrollView delegate methods
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber=scrollView.contentOffset.x/scrollView.frame.size.width
        pageControl.currentPage=Int(pageNumber)
        
    }

    @IBAction func LoginBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "goToSignUpVC", sender: self)
    }
    
}

