//
//  PlayGroundDetailsVC.swift
//  Vie
//
//  Created by user137691 on 11/19/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit

class PlayGroundDetailsVC: UIViewController,UIScrollViewDelegate {
    
    var playGroundobj=PlayGround()
    var frame=CGRect(x: 0, y: 0, width: 0, height: 0)
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var images=playGroundobj.ImagesLocation
        for index in 0..<images.count
        {
            frame.origin.x=scrollView.frame.size.width*CGFloat(index)
            frame.size=scrollView.frame.size
            let imageView=UIImageView(frame:frame)
            if let url=URL(string: images[index]){
                if let data=try? Data(contentsOf: url){
                    imageView.image=UIImage(data: data)
                }
            }
            self.scrollView.addSubview(imageView)
        }
        scrollView.contentSize=CGSize(width: (scrollView.frame.size.width * CGFloat(images.count)), height: scrollView.frame.size.height)
        
    }
    



}
