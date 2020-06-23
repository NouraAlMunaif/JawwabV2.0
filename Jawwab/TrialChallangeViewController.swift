//
//  TrialChallangeViewController.swift
//  Jawwab
//
//  Created by Latif Ath on 3/19/19.
//  Copyright © 2019 atheer. All rights reserved.
//

import UIKit
import ARKit
import Firebase

class TrialChallangeViewController: UIViewController {
    let lang = UserDefaults.standard.object(forKey: "lang") as? Int
    @IBOutlet weak var myimage: UIImageView!
    let userId = UserDefaults.standard.object(forKey: "userId") as? String
    var ref: DatabaseReference!
    
    var flag = false
    
    @IBOutlet weak var profile: UIButton!
    
    @IBOutlet weak var rewards: UILabel!
    @IBOutlet weak var rewardIcon: UIButton!
    @IBOutlet weak var map: UIButton!
    @IBOutlet weak var leaderboard: UIButton!
    @IBOutlet weak var silfie: UIButton!
    @IBOutlet weak var popupgood: UIImageView!
    @IBOutlet weak var closegood: UIButton!
    @IBOutlet weak var icongood: UIImageView!
    @IBOutlet weak var labelgood: UILabel!
    
    let sceneView = ARSCNView()
    var node2: SCNNode!

    @IBOutlet weak var skipch: UIButton!
    
    
    //    func handelbacgroung(_ popup: Popup) {
    //        visualEffectView.alpha = 0
    //    }
     
    
 
    
    @IBOutlet weak var popUp: UIView!
    @IBOutlet weak var mytext: UILabel!
    @IBOutlet weak var but1: UIButton!
    @IBOutlet weak var but2: UIButton!
    @IBOutlet weak var points: UIButton!
    @IBOutlet weak var but3: UIButton!
    @IBOutlet weak var but4: UIButton!
    
    
    @IBOutlet weak var nextbtn: UIButton!
    
    var intrCounter = 1
    var counter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.sceneView)
        
        
        //add autolayout contstraints
        self.sceneView.translatesAutoresizingMaskIntoConstraints = false
        self.sceneView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.sceneView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.sceneView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.view.sendSubviewToBack(self.sceneView)
        
        
        solveChallange(q: 1, status: 1)
        setCurrent(q: 1)
        
       popupgood.isHidden = true
       closegood.isHidden = true
       icongood.isHidden = true
       labelgood.isHidden = true
        let userId = UserDefaults.standard.object(forKey: "userId") as? String
        ref = Database.database().reference()
        let userGender = ref.child("users").child(userId!).child("Gender")
        userGender.observeSingleEvent(of: .value, with: { (snapshot) in
            let gender = snapshot.value as? Int
            if(gender==1){
                self.myimage.image = UIImage(named:"intrgirl.png")}
            if(gender==0){
                self.myimage.image = UIImage(named:"instboy.png")}
        })
        
     
        
        
        ref = Database.database().reference()
        let  userLang = ref.child("users").child(userId!).child("lang")
        userLang.observeSingleEvent(of: .value, with: { (snapshot) in
            let lang = snapshot.value as? Int
            if(lang==1){
                var text = "The map shows the place of the challenges"
                self.mytext.text = text
                self.mytext.animate(newText: self.mytext.text ?? "May the source be with you", characterDelay: 1)
                self.nextbtn.setBackgroundImage(UIImage(named: "NextInstrecSmalleng"), for: UIControl.State.normal)
                  self.skipch.setBackgroundImage(UIImage(named: "Skipchalangeeng"), for: UIControl.State.normal)
            }
            
            if(lang==0){
                
                self.mytext.animate(newText: self.mytext.text ?? "May the source be with you", characterDelay: 1)
                
                
            }
        })
        
        
        
        but2.isHidden = true
        points.isHidden = true
        but3.isHidden = true
        but4.isHidden = true
        
        
        self.EndUserSession()
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
    
    @IBAction func skipchallange(_ sender: Any) {
        rewards.removeFromSuperview()
        rewardIcon.removeFromSuperview()
        map.removeFromSuperview()
        leaderboard.removeFromSuperview()
        silfie.removeFromSuperview()
        popupgood.removeFromSuperview()
        closegood.removeFromSuperview()
        icongood.removeFromSuperview()
        labelgood.removeFromSuperview()
        popUp.removeFromSuperview()
        profile.removeFromSuperview()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "mainView") as! Question1ViewController
        UIApplication.shared.keyWindow?.rootViewController = tabBarController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    
    
    
    @IBAction func nexttip(_ sender: Any) {
        counter = counter + 1
        mytext.text = ""
        
        var w2 = ""
        var w4 = ""
        var w5 = ""
        var w6 = ""
        var w7 = ""
        var w8 = ""
        var w9 = ""
        
        var instructions = ["lol"]
        
        ref = Database.database().reference()
        let  userLang = ref.child("users").child(userId!).child("lang")
        userLang.observeSingleEvent(of: .value, with: { (snapshot) in
            let lang = snapshot.value as? Int
            if(lang==1){
                
                w2 = "The points are increased by answering correctly"
                w4 = "Here leading players appear with their points"
                w5 = "You can view your profile here"
                w6 = "Take a selfie at any time during the tour"
                w7 = "Move your phone screen to the right and left"
                w8 = "Move your phone screen to up and down"
                w9 = "Look for the hidden tree"
                
            }
            
            if(lang==0){
                w2 = "النقاط تزداد بإجابتك بشكل صحيح"
                w4 = "هنا يظهر اللاعبين المتصدرين ونقاطهم"
                w5 = "بإمكانك شاهدة ملفك الشخصي من هنا"
                w6 = "التقط صورة في أي وقت"
                w7 = "حرك الجهاز لليمين واليسار"
                w8 = "حرك الجهاز لأعلى وأسفل"
                w9 = "ابحث عن الشجرة المفقودة"
                
            }
            
            instructions.append(w2)
            instructions.append(w4)
            instructions.append(w5)
            instructions.append(w6)
            instructions.append(w7)
            instructions.append(w8)
            instructions.append(w9)
            
            if(self.intrCounter < 8){
                
                
                var new = instructions[self.intrCounter]
                
                self.mytext.text = new
                
                self.mytext.animate(newText: new ?? "May the source be with you", characterDelay: 1)
                self.intrCounter = self.intrCounter + 1
                
                
                
                switch self.intrCounter {
                    
                case 2:
                    self.points.isHidden = false
                    self.but1.isHidden = true
                    
                case 3:
                    self.points.isHidden = true
                    self.but2.isHidden = false
                    
                case 4:
                    
                    self.but2.isHidden = true
                    self.but3.isHidden = false
                    
                case 5:
                    self.but3.isHidden = true
                    self.but4.isHidden = false
                    print("Some other character")
                case 6:
                     self.but4.isHidden = true
                    self.skipch.isHidden = true

                
               // case 7:
                    //
              case 8:
                   self.popUp.backgroundColor = UIColor(white: 1, alpha: 0)
                    
                default:
                    print("Some other character")
                }
            
            }
                
            else{
                
               if ( self.intrCounter == 8 ){

                   self.popUp.isHidden = true
                self.displayAR()

               }
            }
            
            
            
            
        })
        
        
      if(counter == 8){
      //flag = true
        
        
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
 /*   override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    */
    
    // Do any additional setup after loading the view.
    
    @IBAction func close(_ sender: Any) {
   /*     let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let Question1ViewController = storyBoard.instantiateViewController(withIdentifier: "mainView") as! Question1ViewController
        
        self.present(Question1ViewController, animated: true, completion: nil) */
        rewards.removeFromSuperview()
        rewardIcon.removeFromSuperview()
        map.removeFromSuperview()
        leaderboard.removeFromSuperview()
        silfie.removeFromSuperview()
        popupgood.removeFromSuperview()
        closegood.removeFromSuperview()
        icongood.removeFromSuperview()
        labelgood.removeFromSuperview()
        popUp.removeFromSuperview()
        profile.removeFromSuperview()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "mainView") as! Question1ViewController
        UIApplication.shared.keyWindow?.rootViewController = tabBarController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if ( flag == false) {
            return false }
        return true
    }
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    ////// To display the AR object for trial challenge ////////////
    func displayAR(){
        let scene = SCNScene(named: "art.scnassets/tree.scn")
        ////////AR tree 3D object
        node2 = scene!.rootNode.childNode(withName: "tree", recursively: false)
        sceneView.scene = scene!
        
        print ("IN DISPLAYING AR")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as! UITouch
        if(touch.view == self.sceneView){
            print("touch working")
            let viewTouchLocation:CGPoint = touch.location(in: sceneView)
            guard let result = sceneView.hitTest(viewTouchLocation, options: nil).first else {
                return
            }
            
            if (node2.contains(result.node)) { //to ensure which 3d object was touched
                solveChallange(q: 1, status: 1)
                setCurrent(q: 1)
                node2.removeFromParentNode()
                popupgood.isHidden = false
                closegood.isHidden = false
                icongood.isHidden = false
                if (lang==1){
                    
                    labelgood.text = "Start your tour and solve the challenges!"
                }
                labelgood.isHidden = false
                
            }
            
        }
        
    }
    
   
    
}

