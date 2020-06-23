//
//  SpaceChallangePopupViewController.swift
//  Jawwab
//
//  Created by Latif Ath on 3/23/19.
//  Copyright © 2019 atheer. All rights reserved.
//

import UIKit
import ARKit
import Firebase
class SpaceChallangePopupViewController: UIViewController {
    @IBOutlet weak var info: UILabel!
    let userId = UserDefaults.standard.object(forKey: "userId") as? String
    let lang = UserDefaults.standard.object(forKey: "lang") as? Int
    @IBOutlet weak var detalies: UILabel!
  //  @IBOutlet weak var rewardIcon: UIButton!
    let gender = UserDefaults.standard.object(forKey: "gender") as? Int
    var ref: DatabaseReference!
    //   let sceneView = ARSCNView()
//    @IBOutlet weak var rewards: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
  //      self.view.addSubview(self.sceneView)
        
        
        if(lang == 1){
            info.text = "Information"
            detalies.text = "Arabs discovered that earth is round for the first time"
        }
        
        //add autolayout contstraints
  /*      self.sceneView.translatesAutoresizingMaskIntoConstraints = false
        self.sceneView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.sceneView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.sceneView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.view.sendSubviewToBack(self.sceneView)
        // Do any additional setup after loading the view.
        */
        self.updateRewards()
        self.EndUserSession()
    }
    
    
    @IBAction func close(_ sender: Any) {
 //       sceneView.removeFromSuperview()
    //    rewards.removeFromSuperview()
      //  rewardIcon.removeFromSuperview()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let Question1ViewController = storyBoard.instantiateViewController(withIdentifier: "mainView") as! Question1ViewController
        
        self.present(Question1ViewController, animated: false, completion: nil)
        
    }
    
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
    
    func updateRewards(){
        let userId = UserDefaults.standard.object(forKey: "userId") as? String
        ref = Database.database().reference()
        
        let userscore = ref.child("users").child(userId!).child("UserScore")
        userscore.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let score = snapshot.value as? String{
                var score1 = Int(score)
                score1 = score1! + 10
                self.passingScore(score1: score1!)
            }
        })
        
    }
    
    
    func passingScore(score1: Int){
        ref = Database.database().reference()
        let score2 = String(score1)
        ref.child("users").child(userId!).child("UserScore").setValue(score2)
     //   rewards.text = "\(score1)"
    }
}
