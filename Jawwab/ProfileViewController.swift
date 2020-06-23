//
//  ProfileViewController.swift
//  Jawwab
//
//  Created by Nouf on 2/23/19.
//  Copyright © 2019 atheer. All rights reserved.
//

import UIKit
import Firebase
class ProfileViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var popup: UIView!
    
    let userId = UserDefaults.standard.object(forKey: "userId") as? String
    let lang = UserDefaults.standard.object(forKey: "lang") as? Int
    var ref: DatabaseReference!
    
    @IBOutlet weak var CharName: UILabel!
    @IBOutlet weak var charScore: UILabel!
    @IBOutlet weak var charLevel: UILabel!
    @IBOutlet weak var charImage: UIImageView!
    
    
    @IBOutlet weak var levelbox: UIImageView!

    @IBOutlet weak var pointsbox: UIImageView!
    
    @IBOutlet weak var badgesbox: UIImageView!
    // levelContinereng
    // pointsContinereng
    // badgesContinereng
    
    var p = 0
    
    @IBOutlet weak var endYes: UIButton!
    @IBOutlet weak var endNo: UIButton!
    @IBOutlet weak var endText: UILabel!
    
    @IBOutlet weak var endIPicon: UIImageView!
    @IBOutlet weak var endPopup: UIImageView!
    @IBOutlet weak var b1: UIImageView!
    @IBOutlet weak var b2: UIImageView!
    @IBOutlet weak var b3: UIImageView!
    @IBOutlet weak var b4: UIImageView!
    
    // inital badges
    var badges = ["badge1.png", "badge2.png", "badge3.png", "badge4.png"]
    
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
        endYes.isHidden = true
        endNo.isHidden = true
        endText.isHidden = true
        endIPicon.isHidden = true
        endPopup.isHidden = true
        
        if (lang == 1){
           endText.text = "Are you sure you want to end the tour?"
            endPopup.image = UIImage(named:"confirmation.png")
            endNo.setTitle("No", for: .normal)
            endYes.setTitle("Yes", for: .normal)

        }
        
        
        
        
        self.EndUserSession()
        ref = Database.database().reference()
        let  userLang = ref.child("users").child(userId!).child("lang")
        userLang.observeSingleEvent(of: .value, with: { (snapshot) in
            let lang = snapshot.value as? Int
            if(lang==1){
               self.levelbox.image = UIImage(named:"levelContinereng.png")
               self.pointsbox.image = UIImage(named:"pointsContinereng.png")
                self.badgesbox.image = UIImage(named:"badgesContinereng.png")
                
            }
            
            
        })
  
        
        ///////////////// character image retrieval into the profile////////////////
        ref = Database.database().reference()
        let userGender = ref.child("users").child(userId!).child("Gender")
        userGender.observeSingleEvent(of: .value, with: { (snapshot) in
            let gender = snapshot.value as? Int
            if(gender==1){
                self.charImage.image = UIImage(named:"girl.jpg")
                self.charImage.image = #imageLiteral(resourceName: "girl")}
            if(gender==0){
                self.charImage.image = UIImage(named:"boy.jpg")
                self.charImage.image = #imageLiteral(resourceName: "boy")}
        })
        
        /////////// character image retrieval into the profile////////////////
        
        
        
        
        
        ///////////// character name retrieval into the profile////////////////
        ref = Database.database().reference()
        let userName = ref.child("users").child(userId!).child("Name")
        userName.observeSingleEvent(of: .value, with: { (snapshot) in
            let name = snapshot.value as? String
            self.CharName.text = name
        })
        ////////////// character name retrieval into the profile////////////////
        
        
        
        
        ////////////// character score retrieval into the profile////////////////
        ref = Database.database().reference();
        
        
        let userscore = ref.child("users").child(userId!).child("UserScore")
        userscore.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let score = snapshot.value as? String{
                let score1 = Int(score)
                var score2 = score1!
                self.charScore.text = "\(score2)"
            }
        })
        
        
        //        ref = Database.database().reference()
        //        let userScore = ref.child("users").child(userId!).child("UserScore")
        //        userScore.observeSingleEvent(of: .value, with: { (snapshot) in
        //            var score = snapshot.value as? Int
        //            var score1 = score!
        //            self.charScore.text = "\(score1)"
        //
        //        })
        ////////////// character score retrieval into the profile////////////////
        
        
        
        
        
        /////////////////// character level retrieval into the profile ////////////////
        ref = Database.database().reference()
        let userLevel = ref.child("tour").child(userId!).child("level")
        userLevel.observeSingleEvent(of: .value, with: { (snapshot) in
            var level = snapshot.value as? Int
            
            
            if (level == 1){
                
                self.b1.image = UIImage(named: self.badges[0])
                
            }
            
            if (level == 2){
                
                self.b1.image = UIImage(named: self.badges[0])
                self.b2.image = UIImage(named: self.badges[1])
            }
            
            if (level == 3 ){
                self.b1.image = UIImage(named: self.badges[0])
                self.b2.image = UIImage(named: self.badges[1])
                self.b3.image = UIImage(named: self.badges[2])
            }
            
            if (level == 4) {
                self.b1.image = UIImage(named: self.badges[0])
                self.b2.image = UIImage(named: self.badges[1])
                self.b3.image = UIImage(named: self.badges[2])
                self.b4.image = UIImage(named: self.badges[3])
            }
            
            var level1 = level!
            
            if level == 0 {
                level1 = level! + 1
            }
            
            self.charLevel.text = "\(level1)"
            
            
            
        })
        
        
        
    }
    
    
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        return badges.count
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BadgeCollectionViewCell
    //
    //       // cell.badage.image = UIImage(named: badges[indexPath.row])
    //        cell.label.text = badges[indexPath.row]
    //        return cell
    //    }
    
    
    
    /// End Tour //
    
    
    @IBAction func endNoBurron(_ sender: Any) {
        
        endYes.isHidden = true
        endNo.isHidden = true
        endText.isHidden = true
        endIPicon.isHidden = true
        endPopup.isHidden = true
        
    }
    
    
    @IBAction func endYesButton(_ sender: Any) {
    
        /// 1- first destory the session
        
        UserDefaults.standard.removeObject(forKey: self.userId!)
        

        ////2-  transfer user to registartio page///
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ViewController = storyBoard.instantiateViewController(withIdentifier: "registerPage") as! ViewController
        self.present(ViewController, animated: true, completion: nil)
    }
    
    @IBAction func endTour(_ sender: Any) {
        
        
       endYes.isHidden = false
       endNo.isHidden = false
        
        endText.isHidden = false
        endIPicon.isHidden = false
        endPopup.isHidden = false
  
    }
    
       
        
    
    
    
    
    @IBAction func close(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    
    
    
    
}


