//
//  PlayGroundReservationVC.swift
//  Vie
//
//  Created by user137691 on 12/9/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import SwiftyJSON
class PlayGroundReservationVC: UIViewController {
 
    var playGroundobj=PlayGround()
    var displayeddates=[String]()
    var dates=[Date]()
    
    var periods=[Period]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.separatorEffect = .none
        //Remove Extra Celss
        tableView.tableFooterView=UIView()
        //Init Date Array
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="dd \n MMM"
        let dayFormatter=DateFormatter()
        dayFormatter.dateFormat="EEEE"
        for i in 0...15{
            let date=Calendar.current.date(byAdding: .day, value: i, to: Date())
            let dateMonthAndYear=dateFormatter.string(from:date!)
            let dayInWeek=dayFormatter.string(from: date!)
            dates.append(date!)
            displayeddates.append(dayInWeek.prefix(3) + " \n " + dateMonthAndYear)
            
        }
        ///
      // setScrollIndicatorColor(color: UIColor.red)
       
        GetPeriodsForDate(date:Date())
    }
   
    func setScrollIndicatorColor(color: UIColor) {
        for view in self.dateCollectionView.subviews {
            if view.isKind(of: UIImageView.self),
                let imageView = view as? UIImageView,
                let image = imageView.image  {
                
                imageView.tintColor = color
                imageView.image = image.withRenderingMode(.alwaysTemplate)
            }
        }
        
        self.dateCollectionView.flashScrollIndicators()
    }
    func IsKeyPresentInUserDefaults(key:String)->Bool{
        return UserDefaults.standard.object(forKey: key) != nil
    }
    func GetPeriodsForDate(date:Date){
        let dateFormatters=DateFormatter()
        dateFormatters.dateFormat="yyyy-MM-dd"
        let apiDateFormate=dateFormatters.string(from: date)
        if(IsKeyPresentInUserDefaults(key: "AccessToken"))
        {
            Period.GetPeriods(date: apiDateFormate, PlayGroundIDHashed: playGroundobj.PlayGroundIDHashed) { (periodsarray) in
                self.periods=periodsarray
                self.tableView.reloadData()
            }
        }
    }
    
 
    
}
extension PlayGroundReservationVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return periods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let periodObj=periods[indexPath.row]
        let x = (periodObj.Ml3byPrice==periodObj.Price)
        //price label
        let mutableAttripuatedString=NSMutableAttributedString()
        let priceAttributeString: NSMutableAttributedString =  NSMutableAttributedString(string: String(periodObj.Price))
        priceAttributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, priceAttributeString.length))
        priceAttributeString.addAttribute(NSAttributedString.Key.foregroundColor,value:UIColor.gray, range: NSMakeRange(0, priceAttributeString.length))
        
        let ml3byPriceAttributeString: NSMutableAttributedString =  NSMutableAttributedString(string: String(periodObj.Ml3byPrice))
        ml3byPriceAttributeString.addAttribute(NSAttributedString.Key.foregroundColor,value:periodObj.IsReserved ? UIColor.white : UIColor.red, range: NSMakeRange(0, ml3byPriceAttributeString.length))
        mutableAttripuatedString.append(priceAttributeString)
        mutableAttripuatedString.append(NSMutableAttributedString(string: "\n"))
        mutableAttripuatedString.append(ml3byPriceAttributeString)
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "PeriodCell", for: indexPath) as! PeriodCell
        cell.periodTimeLabel.text=periodObj.StartTime + " - " + periodObj.EndTime
        
        cell.periodPriceLabel.attributedText=x ? NSAttributedString(string: String(periodObj.Price)) : mutableAttripuatedString
        let reservedText="محجوز"
        cell.periodValidationLabel.text=periodObj.IsReserved ? reservedText : "متاح"
        cell.periodValidationLabel.textColor = periodObj.IsReserved ? UIColor.white :UIColor.green
        cell.periodTimeLabel.textColor = periodObj.IsReserved ? UIColor.white :UIColor.green
        if(x){
            cell.periodPriceLabel.textColor = periodObj.IsReserved ? UIColor.white :UIColor.green
        }
        cell.view.backgroundColor=periodObj.IsReserved ? UIColor.red : UIColor.white
        // cell.view.frame=cell.frame.offsetBy(dx: 10, dy: 10)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "هل ترغب في الحجز؟", message: "في حالة الحجز سيت إرسال رقم هاتفك المسجل في تطبيق Vie إلى صاحب الملعب ليتواصل معك بخصوص الحجز.", preferredStyle: .alert)
        let okAction=UIAlertAction(title: "احجز الملعب", style: .default) { (action) in
            self.performSegue(withIdentifier: "goToReservationInfoVC", sender: self)
        }
        let cancelAction=UIAlertAction(title: "لا،شكرا", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert,animated: true)
    }
}
extension PlayGroundReservationVC:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        GetPeriodsForDate(date: dates[indexPath.row])
        tableView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayeddates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
        cell.DayLabel.text=displayeddates[indexPath.row]
        return cell
    }}
