//
//  QuestionViewController.swift
//  Proximity
//
//  Created by Reema on 24/01/2019.
//  Copyright © 2019 Estimote, Inc. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation //kit for the sounds effects
import EstimoteProximitySDK
import SceneKit
import ARKit



class QuestionViewController: UIViewController , ARSCNViewDelegate{
    
    var ref: DatabaseReference!
    var optionsArray = [String]()
    var player: AVAudioPlayer?
    var node: SCNNode!
    let sceneView = ARSCNView()
    let lang = UserDefaults.standard.object(forKey: "lang") as? Int

 //   var configuration = ARWorldTrackingConfiguration()

    @IBOutlet weak var coinIcon: UIButton!
    //   @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var opt2: UIButton!
    @IBOutlet weak var opt1: UIButton!
    //  @IBOutlet weak var opt1: UIButton!
    //  @IBOutlet weak var opt2: UIButton!
    
    @IBOutlet weak var opt3: UIButton!
    // @IBOutlet weak var opt3: UIButton!
    
    @IBOutlet weak var tryAgainBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var reward: UILabel!
    // @IBOutlet weak var sceneView: ARSCNView!
    //    let sceneView = ARSCNView()
    // storyboard elements
    // @IBOutlet weak var Qview: UITextView!
    //options for the question
    //  @IBOutlet weak var answersView: UIView!
    //   @IBOutlet weak var opt1: UIButton!
    //   @IBOutlet weak var opt2: UIButton!
    //   @IBOutlet weak var opt3: UIButton!
    
    var questionNum : String?
    let userId = UserDefaults.standard.object(forKey: "userId") as? String
    //   @IBOutlet weak var label2: UIView!
    //   @IBOutlet weak var label1: UIView!
    var proximityObserver: ProximityObserver!
    
    
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
    @IBAction func skipButton(_ sender: Any) {
        solveChallange(q: 3, status: 2)
        setCurrent(q: 3)
        coinIcon.removeFromSuperview()
        reward.removeFromSuperview()
        skipBtn.removeFromSuperview()
        tryAgainBtn.removeFromSuperview()
        btn1.removeFromSuperview()
        btn2.removeFromSuperview()
        btn3.removeFromSuperview()
        opt1.removeFromSuperview()
        opt2.removeFromSuperview()
        opt3.removeFromSuperview()
        self.node.removeFromParentNode()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let skipViewController = storyBoard.instantiateViewController(withIdentifier: "skip") as! skipViewController
        
        self.present(skipViewController, animated: false, completion: nil)
    }
    
    @IBAction func tryAgainButton(_ sender: Any) {
        let parent = view.superview
        sceneView.removeFromSuperview()
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
       
    }
    
    func updateRewards(){
        
        ref = Database.database().reference()
        
        
        let userscore = ref.child("users").child(userId!).child("UserScore")
        userscore.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let score = snapshot.value as? String{
                let score1 = Int(score)
                print(score1!)
                self.passingScore(score1: score1!)
            }
        })
        
        
    }
    
    
    func passingScore(score1: Int){
  //      ref = Database.database().reference()
        let score2 = String(score1)
    //    ref.child("users").child(userId!).child("UserScore").setValue(score2)
        //let score2 = String(score1);
        reward.text = score2
    }
    

    
    @IBAction func click1(_ sender: Any) {
        if (opt1.titleLabel?.text) != nil {
            let userAnswer=opt1.titleLabel?.text;
            if ((userAnswer!.elementsEqual(self.optionsArray[0])) == true)
            {
                solveChallange(q: 3, status: 1)
                setCurrent(q: 3)
      //          rewardsUpdate()
             //    sceneView.removeFromSuperview()
                coinIcon.removeFromSuperview()
                reward.removeFromSuperview()
                skipBtn.removeFromSuperview()
                tryAgainBtn.removeFromSuperview()
                btn1.removeFromSuperview()
                btn2.removeFromSuperview()
                btn3.removeFromSuperview()
                opt1.removeFromSuperview()
                opt2.removeFromSuperview()
                opt3.removeFromSuperview()
                self.node.removeFromParentNode()
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let SuccessMessagesViewController = storyBoard.instantiateViewController(withIdentifier: "QMessage") as! SuccessMessagesViewController
                
                self.present(SuccessMessagesViewController, animated: true, completion: nil)
            }
            else {
        //        sceneView.removeFromSuperview()
                coinIcon.removeFromSuperview()
                reward.removeFromSuperview()
                skipBtn.removeFromSuperview()
                tryAgainBtn.removeFromSuperview()
                btn1.removeFromSuperview()
                btn2.removeFromSuperview()
                btn3.removeFromSuperview()
                opt1.removeFromSuperview()
                opt2.removeFromSuperview()
                opt3.removeFromSuperview()
                self.node.removeFromParentNode()
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let wrongMessageViewController = storyBoard.instantiateViewController(withIdentifier: "wrongMessage") as! wrongMessageViewController
                self.present(wrongMessageViewController, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func click2(_ sender: Any) {
        //  ref = Database.database().reference();
        if (opt2.titleLabel?.text) != nil {
            let userAnswer=opt2.titleLabel?.text;
            
            if ((userAnswer!.elementsEqual(self.optionsArray[0])) == true)
            {
                solveChallange(q: 3, status: 1)
                setCurrent(q: 3)
       //         rewardsUpdate()
                
         //        sceneView.removeFromSuperview()
                coinIcon.removeFromSuperview()
                reward.removeFromSuperview()
                skipBtn.removeFromSuperview()
                tryAgainBtn.removeFromSuperview()
                btn1.removeFromSuperview()
                btn2.removeFromSuperview()
                btn3.removeFromSuperview()
                opt1.removeFromSuperview()
                opt2.removeFromSuperview()
                opt3.removeFromSuperview()
                self.node.removeFromParentNode()
                
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let SuccessMessagesViewController = storyBoard.instantiateViewController(withIdentifier: "QMessage") as! SuccessMessagesViewController
                
                self.present(SuccessMessagesViewController, animated: true, completion: nil)
                
                
            }
            else {
                
        //         sceneView.removeFromSuperview()
                coinIcon.removeFromSuperview()
                reward.removeFromSuperview()
                skipBtn.removeFromSuperview()
                tryAgainBtn.removeFromSuperview()
                btn1.removeFromSuperview()
                btn2.removeFromSuperview()
                btn3.removeFromSuperview()
                opt1.removeFromSuperview()
                opt2.removeFromSuperview()
                opt3.removeFromSuperview()
                self.node.removeFromParentNode()
                
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let wrongMessageViewController = storyBoard.instantiateViewController(withIdentifier: "wrongMessage") as! wrongMessageViewController
                
                self.present(wrongMessageViewController, animated: true, completion: nil)
            }
            
            
            
        }
    }
    
    @IBAction func click3(_ sender: Any) {
        if (opt3.titleLabel?.text) != nil {
            let userAnswer=opt3.titleLabel?.text;
            
            if ((userAnswer!.elementsEqual(self.optionsArray[0])) == true)
            {
                solveChallange(q: 3, status: 1)
                setCurrent(q: 3)
     //           rewardsUpdate()
         //        sceneView.removeFromSuperview()
                coinIcon.removeFromSuperview()
                reward.removeFromSuperview()
                skipBtn.removeFromSuperview()
                tryAgainBtn.removeFromSuperview()
                btn1.removeFromSuperview()
                btn2.removeFromSuperview()
                btn3.removeFromSuperview()
                opt1.removeFromSuperview()
                opt2.removeFromSuperview()
                opt3.removeFromSuperview()
                self.node.removeFromParentNode()
                
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let SuccessMessagesViewController = storyBoard.instantiateViewController(withIdentifier: "QMessage") as! SuccessMessagesViewController
                
                self.present(SuccessMessagesViewController, animated: true, completion: nil)
                
                
            }
            else {
                
 //                sceneView.removeFromSuperview()
                coinIcon.removeFromSuperview()
                reward.removeFromSuperview()
                skipBtn.removeFromSuperview()
                tryAgainBtn.removeFromSuperview()
                btn1.removeFromSuperview()
                btn2.removeFromSuperview()
                btn3.removeFromSuperview()
                opt1.removeFromSuperview()
                opt2.removeFromSuperview()
                opt3.removeFromSuperview()
                self.node.removeFromParentNode()
                
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let wrongMessageViewController = storyBoard.instantiateViewController(withIdentifier: "wrongMessage") as! wrongMessageViewController
                
                self.present(wrongMessageViewController, animated: true, completion: nil)
            }
            
            
            
            
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
    
    
    override func viewDidLoad(){  DispatchQueue.main.async {
        super.viewDidLoad()
        
         self.view.addSubview(self.sceneView)
         
         //add autolayout contstraints
         self.sceneView.translatesAutoresizingMaskIntoConstraints = false
         self.sceneView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
         self.sceneView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
         self.sceneView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
         self.sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
         self.view.sendSubviewToBack(self.sceneView)
 
        self.sceneView.delegate = self as! ARSCNViewDelegate
        self.playSound(fileName: "popUp")
        self.getNumOfQuestions();
        self.configureLighting()
        
        self.EndUserSession()
        //self.label1.layer.masksToBounds = true
        //     self.label1.layer.cornerRadius = 15
        
        //self.label2.layer.masksToBounds = true
        //self.label2.layer.cornerRadius = 15
        self.updateRewards()
        
        /*     let estimoteCloudCredentials = CloudCredentials(appID: "jawab-test-2m5", appToken: "6ff2355c245c7d7953c64eb5c2a912ba")
         
         self.proximityObserver = ProximityObserver(credentials: estimoteCloudCredentials, onError: { error in
         print("ProximityObserver error: \(error)")
         })
         
         let zone = ProximityZone(tag: "jawab-test-2m5", range: ProximityRange.near)
         
         zone.onExit = { contexts in
         print("Exit from Question view controller")
         
         let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let Question1ViewController = storyBoard.instantiateViewController(withIdentifier: "mainView") as! Question1ViewController
         
         self.present(Question1ViewController, animated: true, completion: nil)
         }
         
         
         self.proximityObserver.startObserving([zone])
         
         */
        
        }
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func pointInFrontOfPoint(point: SCNVector3, direction: SCNVector3, distance: Float) -> SCNVector3 {
        var x = Float()
        var y = Float()
        var z = Float()
        
        x = point.x + distance * direction.x
        y = point.y + distance * direction.y
        z = point.z + distance * direction.z
        
        let result = SCNVector3Make(x, y, z)
        return result
    }
    
    func calculateCameraDirection(cameraNode: SCNNode) -> SCNVector3 {
        let x = -cameraNode.rotation.x
        let y = -cameraNode.rotation.y
        let z = -cameraNode.rotation.z
        let w = cameraNode.rotation.w
        let cameraRotationMatrix = GLKMatrix3Make(cos(w) + pow(x, 2) * (1 - cos(w)),
                                                  x * y * (1 - cos(w)) - z * sin(w),
                                                  x * z * (1 - cos(w)) + y*sin(w),
                                                  
                                                  y*x*(1-cos(w)) + z*sin(w),
                                                  cos(w) + pow(y, 2) * (1 - cos(w)),
                                                  y*z*(1-cos(w)) - x*sin(w),
                                                  
                                                  z*x*(1 - cos(w)) - y*sin(w),
                                                  z*y*(1 - cos(w)) + x*sin(w),
                                                  cos(w) + pow(z, 2) * ( 1 - cos(w)))
        
        let cameraDirection = GLKMatrix3MultiplyVector3(cameraRotationMatrix, GLKVector3Make(0.0, 0.0, -1.0))
        return SCNVector3FromGLKVector3(cameraDirection)
    }
    
    
    func  DisplayQuestionAndanswer(count: String) {
        DispatchQueue.main.async {
            self.questionNum=count;
            
            /////////// check if the user language is English///////////
            var question = self.ref.child("questions").child(count);

            if (self.lang == 1){
                self.ref = Database.database().reference();
                 question = self.ref.child("questionsEng").child(count);
            }
                
            else {
                /////////// if the user language is Arabic///////////
                self.ref = Database.database().reference();
                 question = self.ref.child("questions").child(count);
                
                
            }
            
            
            question.observe(DataEventType.value, with: { (snapshot) in
                if !snapshot.exists() { return }
                let postDict = snapshot.value as? [String : AnyObject]
                let content = postDict?["content"]
                
                // AR Object
                var text = SCNText(string: content, extrusionDepth: 0.1)
                let material = SCNMaterial()
                material.diffuse.contents = UIColor.black
                text.materials = [material]
                text.font = UIFont(name: "FFHekaya-Light", size: 10)
                
                self.node = SCNNode()
                //     self.node.position = SCNVector3(0, 0 , 0)
                self.node.scale = SCNVector3(0.001, 0.001, 0.001)
                self.node.geometry = text
                text = self.node.geometry as! SCNText
                
                let minVec = self.node.boundingBox.min
                let maxVec = self.node.boundingBox.max
                let bound = SCNVector3Make(maxVec.x - minVec.x,
                                           maxVec.y - minVec.y,
                                           maxVec.z - minVec.z);
                self.node.pivot = SCNMatrix4MakeTranslation(bound.x / 2,
                                                            bound.y / 2,
                                                            bound.z / 2)
                
                let image = UIImage(named: "question")
                let planeNode4 = SCNNode(geometry: SCNPlane(width: 15, height: 15))
                planeNode4.geometry?.firstMaterial?.diffuse.contents = image
                planeNode4.position = SCNVector3(bound.x/2 , 18, 0)
                
                let plane = SCNPlane(width:  CGFloat(bound.x + 15),
                                     height: CGFloat(bound.y + 40))
                plane.cornerRadius = 5
                plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.8)
                
                
                let planeNode = SCNNode(geometry: plane)
                planeNode.position = SCNVector3(CGFloat( minVec.x  ) + CGFloat(bound.x ) / 2 ,
                                                CGFloat( minVec.y ) + CGFloat(bound.y ) / 2,CGFloat(minVec.z - 0.01))
                
                self.node.addChildNode(planeNode)
                self.node.addChildNode(planeNode4)
                planeNode.name = "text"
                let scene = SCNScene()
                let camera = SCNNode()
                camera.name = "cameraNode"
                camera.camera = SCNCamera()
                let dir = self.calculateCameraDirection(cameraNode: camera)
                let pos = self.pointInFrontOfPoint(point: camera.position, direction:dir, distance: 0.4)
                self.node.position = pos
                self.node.orientation = camera.orientation
                self.sceneView.scene.rootNode.addChildNode(self.node)
                
                
                //   self.node.camera = SCNCamera()
                //hh       self.sceneView.pointOfView?.addChildNode(self.node!)
                
                scene.rootNode.addChildNode(self.node)
                
                self.sceneView.scene = scene
            })
            
            var answers = self.ref.child("questions").child(count).child("answers");
            
            if (self.lang == 1 )
            {
                 answers = self.ref.child("questionsEng").child(count).child("answers");
                
            }
            else {
                
                 answers = self.ref.child("questions").child(count).child("answers");
                
            }
            
            answers.observe(DataEventType.value, with: { (snapshot) in
                
                if !snapshot.exists() { return }
                let postDict1 = snapshot.value as? [String : AnyObject]
                let option1 = postDict1?["option1"]
                let option2 = postDict1?["option2"]
                let option3 = postDict1?["option3"]
                
                self.optionsArray.insert(option1 as! String, at: 0)
                self.optionsArray.insert(option2 as! String, at: 1)
                self.optionsArray.insert(option3 as! String, at: 2)
                print("!!!!!!!!!!!!! here correct anser !!!!!!!")
                print(self.optionsArray[0])
                
                let ran1=Int.random(in: 0 ... 2);
                
                var ran2=Int.random(in: 0 ... 2)
                while(ran1==ran2){
                    ran2=Int.random(in: 0 ... 2)}
                
                
                var  ran3=Int.random(in: 0 ... 2);
                while(ran3==ran1||ran3==ran2){
                    ran3=Int.random(in: 0 ... 2);}
                
                
                self.opt1.setTitle(self.optionsArray[ran1] as String?, for: .normal)
                self.opt2.setTitle(self.optionsArray[ran2] as String?, for: .normal)
                self.opt3.setTitle(self.optionsArray[ran3] as String?, for: .normal)
                
            })
            
        }
    }
    
    
    
    func  getNumOfQuestions(){
        
        ref = Database.database().reference();
        
        let numberOfquestions = ref.child("questions")
        numberOfquestions.observe(.value, with: { (snapshot: DataSnapshot!) in
            let numberOfquestions1 = Int(snapshot.childrenCount)
            
            let questionNumber = Int.random(in: 1 ... numberOfquestions1)
            let snum = String(questionNumber)
            
            self.DisplayQuestionAndanswer(count: snum)
        })
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    
/*    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print("Session failed. Changing worldAlignment property.")
        print(error.localizedDescription)
        
        if let arError = error as? ARError {
            switch arError.errorCode {
            case 102:
                configuration.worldAlignment = .gravity
                restartSessionWithoutDelete()
            default:
                restartSessionWithoutDelete()
            }
        }
    }
    
    
    func restartSessionWithoutDelete() {
        // Restart session with a different worldAlignment - prevents bug from crashing app
        self.sceneView.session.pause()
        
        self.sceneView.session.run(configuration, options: [
            .resetTracking,
            .removeExistingAnchors])
    }
    */
    func initChallange(q: Int){
        ref = Database.database().reference();
        var userId = UserDefaults.standard.object(forKey: "userId") as? String
        // 0 ==> not solved  || 1 ==> solved
        self.ref.child("tour").child(userId!).child("q\(q)").setValue(0)
        
    }
    
    func solveChallange(q: Int, status: Int){
        ref = Database.database().reference();
        var userId = UserDefaults.standard.object(forKey: "userId") as? String
        // 0 ==> not solved  // 1 ==> solved
        self.ref.child("tour").child(userId!).updateChildValues(["q\(q)": status])
        
    }
    
    func setCurrent(q: Int){
        ref = Database.database().reference();
        var userId = UserDefaults.standard.object(forKey: "userId") as? String
        self.ref.child("tour").child(userId!).updateChildValues(["current": q])
        
        
    }
    
}

