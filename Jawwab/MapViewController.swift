//
//  MapViewController.swift
//  Jawwab
//
//  Created by Latif Ath on 2/13/19.
//  Copyright © 2019 atheer. All rights reserved.
//

import UIKit
import Firebase

// SetStatus
protocol MapDelegate {
    func setStatus(q: Int)
}

class MapViewController: UIViewController {
    
    var ref: DatabaseReference!
    var userId = UserDefaults.standard.object(forKey: "userId") as? String
    
    
    var status: Dictionary = [String: String]()
    var Lstatus: Dictionary = [String: String]()
    
    @IBOutlet weak var map: UILabel!
    @IBOutlet weak var q1: UIButton!
    @IBOutlet weak var q2: UIButton!
    @IBOutlet weak var q3: UIButton!
    @IBOutlet weak var L1: UIButton!
    @IBOutlet weak var q4: UIButton!
    @IBOutlet weak var q5: UIButton!
    @IBOutlet weak var q6: UIButton!
    @IBOutlet weak var L2: UIButton!
    @IBOutlet weak var q7: UIButton!
    @IBOutlet weak var q8: UIButton!
    @IBOutlet weak var q9: UIButton!
    
    @IBOutlet weak var maplabel: UILabel!
    
    var i = 1
    
    var emptyDict: [Int: String] = [:]
    func EndUserSession(){
        let ref1 = Database.database().reference();
        
        
        let userInfo = ref1.child("users").child(userId!)
        userInfo.observe(DataEventType.value, with: { (snapshot) in
            
            if !snapshot.exists() { return }
            let postDict2 = snapshot.value as? [String : AnyObject]
            let userdate = postDict2?["regDate"] as! String
            let usertime = postDict2?["regTime"] as! String
            
            /// getting today date and time
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let todaydate = formatter.string(from: date)
            
            
            let date1 = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date1)
            let minutes = calendar.component(.minute, from: date1)
            let time = String(hour)  + ":" + String(minutes)
            
            // if the registartion day not the same as today (means once it tomoorow )
            
            if(userdate != todaydate ){
                // the same registration time
                if( usertime == time){
                    
                    /////1- first destory the session/////
                    
                    UserDefaults.standard.removeObject(forKey: self.userId!)
                    
                    
                    
                    ////2- second transfer user to registartio page///
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let ViewController = storyBoard.instantiateViewController(withIdentifier: "registerPage") as! ViewController
                    self.present(ViewController, animated: true, completion: nil)
                    
                }
            }
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let  userLang = ref.child("users").child(userId!).child("lang")
        userLang.observeSingleEvent(of: .value, with: { (snapshot) in
            let lang = snapshot.value as? Int
            if(lang==1){
                self.map.text = "Map"
            }
            
        self.EndUserSession()
        })
    //back here
        ref = Database.database().reference();
        let qustions = ref.child("tour").child(userId!)
        qustions.observe(DataEventType.value, with: { (snapshot) in
            
            if !snapshot.exists() { return }
            let getData = snapshot.value as? [String : AnyObject]
            
            let q1 = getData!["q1"] as? Int
            let q2 = getData!["q2"] as? Int
            let q3 = getData!["q3"] as? Int
            let q4 = getData!["q4"] as? Int
            let q5 = getData!["q5"] as? Int
            let q6 = getData!["q6"] as? Int
            let q7 = getData!["q7"] as? Int
            let q8 = getData!["q8"] as? Int
            let q9 = getData!["q9"] as? Int
            let c = getData!["current"] as? Int
            
            // update qustions
            self.solveChalanges(qNum: 1, qStatus: q1!)
            self.solveChalanges(qNum: 2, qStatus: q2!)
            self.solveChalanges(qNum: 3, qStatus: q3!)
            self.solveChalanges(qNum: 4, qStatus: q4!)
            self.solveChalanges(qNum: 5, qStatus: q5!)
            self.solveChalanges(qNum: 6, qStatus: q6!)
            self.solveChalanges(qNum: 7, qStatus: q7!)
            self.solveChalanges(qNum: 8, qStatus: q8!)
            self.solveChalanges(qNum: 9, qStatus: q9!)
            self.setCurrent(qNum: c!)
           // update level
            if(q1 == 1 && q2 == 1 && q3 == 1){
                self.updateLevel(level: 1)
            }
            if(q4 == 1 && q5 == 1 && q6 == 1){
                self.updateLevel(level: 2)
            }
            
           
            
        })
        
    
    }

    @IBAction func close(_ sender: Any) {
        
       dismiss(animated: true)
    }
    
    
    func setCurrent(qNum: Int){
        
        switch qNum {
            
        case 1:
              q1.setBackgroundImage(UIImage(named: "current" ), for: UIControl.State.normal)
        case 2:
              q2.setBackgroundImage(UIImage(named: "current" ), for: UIControl.State.normal)
        case 3:
              q3.setBackgroundImage(UIImage(named: "current" ), for: UIControl.State.normal)
        case 4:
              q4.setBackgroundImage(UIImage(named: "current" ), for: UIControl.State.normal)
        case 5:
            q5.setBackgroundImage(UIImage(named: "current" ), for: UIControl.State.normal)
        case 6:
            q6.setBackgroundImage(UIImage(named: "current" ), for: UIControl.State.normal)
        case 7:
            q7.setBackgroundImage(UIImage(named: "current" ), for: UIControl.State.normal)
        case 8:
            q8.setBackgroundImage(UIImage(named: "current" ), for: UIControl.State.normal)
        case 9:
            q9.setBackgroundImage(UIImage(named: "current" ), for: UIControl.State.normal)
        default:
            print("Some other character")
        }
        
    }
    
    func solveChalanges(qNum: Int, qStatus: Int){
        
        
       
            // update here
            switch qNum {
            
            case 1:
                if(qStatus == 1){
                    q1.setBackgroundImage(UIImage(named: "solved" ), for: UIControl.State.normal)
                }
                else  if(qStatus == 2){
                    q1.setBackgroundImage(UIImage(named: "skipped" ), for: UIControl.State.normal)
                }
                    
                else {
                    q1.setBackgroundImage(UIImage(named: "qnot" ), for: UIControl.State.normal)
                }
            case 2:
                if(qStatus == 1){
                    q2.setBackgroundImage(UIImage(named: "solved" ), for: UIControl.State.normal)
                }
                else if(qStatus == 2){
                    q2.setBackgroundImage(UIImage(named: "skipped" ), for: UIControl.State.normal)
                }
                else {
                    q2.setBackgroundImage(UIImage(named: "qnot" ), for: UIControl.State.normal)
                }
            case 3:
                if(qStatus == 1){
                    q3.setBackgroundImage(UIImage(named: "solved" ), for: UIControl.State.normal)
                }
                else if (qStatus == 2){
                    q3.setBackgroundImage(UIImage(named: "skipped" ), for: UIControl.State.normal)
                }
                else {
                    q3.setBackgroundImage(UIImage(named: "qnot" ), for: UIControl.State.normal)
                }
            case 4:
                if(qStatus == 1){
                    q4.setBackgroundImage(UIImage(named: "solved" ), for: UIControl.State.normal)
                }
                else if(qStatus == 2){
                    q4.setBackgroundImage(UIImage(named: "skipped" ), for: UIControl.State.normal)
                }
                else {
                    q4.setBackgroundImage(UIImage(named: "qnot" ), for: UIControl.State.normal)
                }
            case 5:
                if(qStatus == 1){
                    q5.setBackgroundImage(UIImage(named: "solved" ), for: UIControl.State.normal)
                }
                else if(qStatus == 2){
                    q5.setBackgroundImage(UIImage(named: "skipped" ), for: UIControl.State.normal)
                }
                else {
                    q5.setBackgroundImage(UIImage(named: "qnot" ), for: UIControl.State.normal)
                }
            case 6:
                if(qStatus == 1){
                    q6.setBackgroundImage(UIImage(named: "solved" ), for: UIControl.State.normal)
                }
                else if(qStatus == 2){
                    q6.setBackgroundImage(UIImage(named: "skipped" ), for: UIControl.State.normal)
                }
                else {
                    q6.setBackgroundImage(UIImage(named: "qnot" ), for: UIControl.State.normal)
                }
                
            case 7:
                if(qStatus == 1){
                    q7.setBackgroundImage(UIImage(named: "solved" ), for: UIControl.State.normal)
                }
                else if(qStatus == 2){
                    q7.setBackgroundImage(UIImage(named: "skipped" ), for: UIControl.State.normal)
                }
                else {
                    q7.setBackgroundImage(UIImage(named: "qnot" ), for: UIControl.State.normal)
                }
                
            case 8:
                if(qStatus == 1){
                    q8.setBackgroundImage(UIImage(named: "solved" ), for: UIControl.State.normal)
                }
                else if(qStatus == 2){
                    q8.setBackgroundImage(UIImage(named: "skipped" ), for: UIControl.State.normal)
                }
                else {
                    q8.setBackgroundImage(UIImage(named: "qnot" ), for: UIControl.State.normal)
                }
                
            case 9:
                if(qStatus == 1){
                    q9.setBackgroundImage(UIImage(named: "solved" ), for: UIControl.State.normal)
                }
                else if(qStatus == 2){
                    q9.setBackgroundImage(UIImage(named: "skipped" ), for: UIControl.State.normal)
                }
                else {
                    q9.setBackgroundImage(UIImage(named: "qnot" ), for: UIControl.State.normal)
                }
            default:
                print("Some other character")
            }
        


        
    }
    
    func updateLevel(level: Int){
        
        
        if(level == 1){
            L1.setBackgroundImage(UIImage(named: "levelSolved" ), for: UIControl.State.normal)
        }
        
        if(level == 2){
           L2.setBackgroundImage(UIImage(named: "levelSolved" ), for: UIControl.State.normal)
        }
        
    }
    
}


