//
//  QMessagesViewController.swift
//  Proximity
//
//  Created by Reema on 27/01/2019.
//  Copyright © 2019 Estimote, Inc. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import ARKit
class SuccessMessagesViewController: UIViewController {
    
 //   let sceneView = ARSCNView()

    @IBOutlet weak var gPopUp: UIImageView!
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var popupLabel: UILabel!
    @IBOutlet weak var popupSubLabel: UILabel!
    
    @IBOutlet weak var rewardsIcon: UIButton!
    @IBOutlet weak var xIcon: UIButton!
    @IBOutlet weak var rewards: UILabel!
    

    //    @IBOutlet weak var label: UILabel!
    var player: AVAudioPlayer?
    let userId = UserDefaults.standard.object(forKey: "userId") as? String
     let gender = UserDefaults.standard.object(forKey: "gender") as? Int
    var ref: DatabaseReference!
        let lang = UserDefaults.standard.object(forKey: "lang") as? Int
    func playSound(fileName: String) {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    
    @IBAction func close(_ sender: Any) {
     //   sceneView.removeFromSuperview()
        gPopUp.removeFromSuperview()
        pic.removeFromSuperview()
        header.removeFromSuperview()
        popupLabel.removeFromSuperview()
        popupSubLabel.removeFromSuperview()
        rewardsIcon.removeFromSuperview()
        xIcon.removeFromSuperview()
        rewards.removeFromSuperview()

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
            let lang = UserDefaults.standard.object(forKey: "lang") as? Int
        self.EndUserSession()
        if(lang == 1){
            header.text = "Excelent"
            popupLabel.text = "Nice Try!"
            popupSubLabel.text = "We are so close to reach the treasure"
        }
        
        if (gender == 1) {
              pic.image = UIImage(named:"girlhappy.png")
        }
       
        //add autolayout contstraints
  /*      self.sceneView.translatesAutoresizingMaskIntoConstraints = false
        self.sceneView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.sceneView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.sceneView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.view.sendSubviewToBack(self.sceneView)
 */
        // Do any additional setup after loading the view.
        playSound(fileName: "success")
       self.updateRewards()
        //print("!!!")
        
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
        rewards.text = "\(score1)"
    }
    

    
}
