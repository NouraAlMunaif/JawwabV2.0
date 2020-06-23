//
//  wrongMessageViewController.swift
//  Proximity
//
//  Created by Reema on 28/01/2019.
//  Copyright © 2019 Estimote, Inc. All rights reserved.
//

import UIKit
import AVFoundation
import ARKit
import Firebase
class wrongMessageViewController: UIViewController {
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var tryAgainPopUp: UIImageView!
    
    @IBOutlet weak var popupTittle: UILabel!
    
    @IBOutlet weak var popupSubtittle: UILabel!
    
    @IBOutlet weak var xIcon: UIButton!
    
    @IBOutlet weak var pic: UIImageView!
    
  
  //  let sceneView = ARSCNView()
    var player: AVAudioPlayer?
    let userId = UserDefaults.standard.object(forKey: "userId") as? String
     let lang = UserDefaults.standard.object(forKey: "lang") as? Int
     let gender = UserDefaults.standard.object(forKey: "gender") as? Int
    @IBAction func close(_ sender: Any) {
     //   sceneView.removeFromSuperview()
        header.removeFromSuperview()
        tryAgainPopUp.removeFromSuperview()
        popupTittle.removeFromSuperview()
        popupSubtittle.removeFromSuperview()
        xIcon.removeFromSuperview()
        pic.removeFromSuperview()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let Question1ViewController = storyBoard.instantiateViewController(withIdentifier: "mainView") as! Question1ViewController
        
        self.present(Question1ViewController, animated: false, completion: nil)
    }
    
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
        if (gender == 1) {
            pic.image = UIImage(named:"girlsad.png")
        }
        
        if (lang == 1){
            header.text = "Try again"
            popupTittle.text = "Wrong Answer"
            popupSubtittle.text = "Don't worry you can try again"
            
        }
       self.EndUserSession()
    }
    
    
    
}
