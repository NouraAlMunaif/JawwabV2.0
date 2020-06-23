//
//  InstructionsViewController.swift
//  Jawwab
//
//  Created by atheer on 1/28/19.
//  Copyright © 2019 atheer. All rights reserved.
//

import UIKit
import ARKit
import Firebase

class InstructionsViewController: UIViewController {
    
    let userId = UserDefaults.standard.object(forKey: "userId") as? String
    var ref: DatabaseReference!
    
    @IBOutlet weak var popUp: UIView!
    
    @IBOutlet weak var mytext: UILabel!
    
    @IBOutlet weak var myImage: UIImageView!
    
    @IBOutlet weak var nextButten: UIButton!
    
    var intrCounter = 1
    var trial = false
    
    var status = [false]
    var counter = 1
        


    
    @IBOutlet weak var sceneView: ARSCNView!
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userId = UserDefaults.standard.object(forKey: "userId") as? String
        ref = Database.database().reference()
        let  userLang = ref.child("users").child(userId!).child("lang")
        userLang.observeSingleEvent(of: .value, with: { (snapshot) in
            let lang = snapshot.value as? Int
            if(lang==1){
                var text = "Hello I have heard there is a hidden treasure in the National Museum"
                self.mytext.text = text
                self.mytext.animate(newText: self.mytext.text ?? "May the source be with you", characterDelay: 1)
                 self.nextButten.setBackgroundImage(UIImage(named: "engnext"), for: UIControl.State.normal)
            }
            
            if(lang==0){
                
                self.mytext.animate(newText: self.mytext.text ?? "May the source be with you", characterDelay: 1)
                
                
            }
        })
        
        
       
        
        
        ref = Database.database().reference()
        let userGender = ref.child("users").child(userId!).child("Gender")
        userGender.observeSingleEvent(of: .value, with: { (snapshot) in
            let gender = snapshot.value as? Int
            if(gender==1){
                
                let image = UIImage(named: "GirlFullBody")
                self.myImage.image = image
            }
            
            if(gender==0){
                
                let image = UIImage(named: "boyFullBody")
                self.myImage.image = image
                
                
            }
        })
        

        
        func setupScene() {
            let scene = SCNScene()
            sceneView.scene = scene
        }
        
        func setupConfiguration() {
            let configuration = ARWorldTrackingConfiguration()
            sceneView.session.run(configuration)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
   
    //////////// function that display the next view ////////////
    
    @IBAction func nextbtt(_ sender: Any) {
        
        var instructions = ["lol"]
        counter = counter + 1
        var w1 = " لكن الوصول إليه يتطلب مواجهة وحل تحديات مختلفة"
        var w2 = "هل بإمكانك مساعدتي  في الحصول على الكنز؟"
        
        let userId = UserDefaults.standard.object(forKey: "userId") as? String
        ref = Database.database().reference()
        let  userLang = ref.child("users").child(userId!).child("lang")
        userLang.observeSingleEvent(of: .value, with: { (snapshot) in
            let lang = snapshot.value as? Int
            if(lang==1){
                ////////////// if user's langague is English
                 w1 = "But finding it requires confronting and solving different challenges"
                 w2 = " Could you help me in getting the treasure"            }

            instructions.append(w1)
            instructions.append(w2)

            if(self.intrCounter < 3){
                
                self.mytext.text = ""
                
                var new = instructions[self.intrCounter]
                
                self.mytext.text = new
                
                self.mytext.animate(newText: new ?? "May the source be with you", characterDelay: 1)
                self.intrCounter = self.intrCounter + 1
                
                if(self.intrCounter == 3){
                    if(lang==1){
                        
                        (sender as AnyObject).setBackgroundImage(UIImage(named: "engready"), for: UIControl.State.normal)
                    }
                    else {
                        (sender as AnyObject).setBackgroundImage(UIImage(named: "ready"), for: UIControl.State.normal)}

                }
            }
                
            else{

            }

        })
        
       
        
        if ( counter == 4){
            status[0] = true
            popUp.removeFromSuperview()
            
        }
     
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if ( status[0] == false ) {
            return false }
        return true
    }
    
}


extension UILabel {
    func animate(newText: String, characterDelay: TimeInterval) {
        text = ""
        var writingTask: DispatchWorkItem?
        writingTask = DispatchWorkItem { [weak weakSelf = self] in
            for character in newText {
                DispatchQueue.main.async {
                    weakSelf?.text!.append(character)
                    
                }
                Thread.sleep(forTimeInterval: characterDelay/100)
            }
        }
        
        if let task = writingTask {
            let queue = DispatchQueue(label: "typespeed", qos: DispatchQoS.userInteractive)
            queue.asyncAfter(deadline: .now() + 0.1, execute: task)
        }
    }
    
}
