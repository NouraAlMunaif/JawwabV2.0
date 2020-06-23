//
// Please report any problems with this app template to contact@estimote.com
//

import UIKit
import ARKit
import EstimoteProximitySDK
import Firebase
struct Content {
    let title: String
    let subtitle: String
}



@available(iOS 11.0, *)
class Question1ViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    
    var flag: Bool = false
    @IBOutlet weak var rewards: UILabel!
    //  @IBOutlet weak var sceneView: ARSCNView!
    let sceneView = ARSCNView()
    //   var planeNode4: SCNNode!
  //  @IBOutlet weak var sceneView: ARSCNView!
    
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var closePopup: UIButton!
    @IBOutlet weak var badgePopup: UIImageView!
    @IBOutlet weak var levelText: UILabel!
    @IBOutlet weak var rewardCoin: UIButton!
    @IBOutlet weak var profile: UIButton!
    @IBOutlet weak var selfie: UIButton!
    @IBOutlet weak var leaderboard: UIButton!
    @IBOutlet weak var mapIcon: UIButton!
    

    var ref: DatabaseReference!
    var proximityObserverBlueBarry: ProximityObserver!
    var proximityObserver: ProximityObserver!
    var flagCoconut = true
    var flagMint = true
    var flagBlueBerry = true
    var flagIce = true
    var flagCoconut2 = false
    var flagMint2 = false
    var flagBlueBerry2 = false
    var flagIce2 = false
    var QuestionAR = [SCNNode]()
    var nearbyContent = [Content]()
    var arrBeacon = [Bool]()
    let fadeDuration: TimeInterval = 0.3
    let rotateDuration: TimeInterval = 3
    let waitDuration: TimeInterval = 0.5
    let userId = UserDefaults.standard.object(forKey: "userId") as? String
    let lang = UserDefaults.standard.object(forKey: "lang") as? Int
    var temp: Bool = false
    var badges = ["badge1.png", "badge2.png", "badge3.png", "badge4.png"]
    
    
    var btnProfile: UIButton = {
        
        let btn=UIButton(type: .system)
        btn.setBackgroundImage(UIImage(named: "sign out-1"), for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
        
        
        
        
    }()
    var btnSelfie: UIButton = {
        
        let btn=UIButton(type: .system)
        btn.setBackgroundImage(UIImage(named: "camera"), for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
        
    }()
    
    
    var btnMap: UIButton = {
        
        let btn=UIButton(type: .system)
        btn.setBackgroundImage(UIImage(named: "map-1"), for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
        
        
    }()
    
    
    var btnLeaderbord: UIButton = {
        
        let btn=UIButton(type: .system)
        btn.setBackgroundImage(UIImage(named: "leaderboard"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
        
    }()
    
    var btnScore: UIButton = {
        
        let btn=UIButton(type: .system)
        btn.setBackgroundImage(UIImage(named: "points"), for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
        
    }()
    
    
    
    
    
    
    func updateRewards(){
        
        ref = Database.database().reference()
        
        
        let userscore = ref.child("users").child(userId!).child("UserScore")
        userscore.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let score = snapshot.value as? String{
                let score1 = Int(score)
                print(score1!)
                print("!!!!!!!!!!!!!!!!!!!!! score1:", score1)
                self.passingScore(score1: score1!)
            }
        })
        
        
    }
    
    
    func passingScore(score1: Int){
       
        //let score2 = String(score1);
          rewards.text = String(score1);
        print("!!!!!!!!!!!!!!!!!!!!! rewards:", rewards.text)
     //    print("!!!!!!!!!!!!!!!!!!!!! score2:", score2)
    }
    
    
    
    
    func updateLevel(level: Int){

        ref = Database.database().reference();
        var userId = UserDefaults.standard.object(forKey: "userId") as? String
        self.ref.child("tour").child(userId!).updateChildValues(["level": level])
        
    }
    

    func checkqustions(){
        let userId = UserDefaults.standard.object(forKey: "userId") as? String
        var leveluser = 8
        ref = Database.database().reference();
        let qs = ref.child("tour").child(userId!)
        qs.observe(DataEventType.value, with: { (snapshot) in
            
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
            
            if(q1 == 1 && q2 == 1 && q3 == 1 && q4 == 0 && q5 == 0 && q6 == 0 && q7 == 0 && q8 == 0 && q9 == 0){
               self.updateLevel(level: 1)
                
            }
         if(q1 == 1 && q2 == 1 && q3 == 1 && q4 == 1 && q5 == 1 && q6 == 1 && q7 == 0 && q8 == 0 && q9 == 0){
                self.updateLevel(level: 2)
              
            }
            
        if(q1 == 1 && q2 == 1 && q3 == 1 && q4 == 1 && q5 == 1 && q6 == 1 && q7 == 1 && q8 == 1 && q9 == 1){
               self.updateLevel(level: 3)
     
            }
            
        })
        
        

    }
    
    func ShowPopup(){
  print("inside showpopup")
        self.checkqustions()
        ref = Database.database().reference()
        let userId = UserDefaults.standard.object(forKey: "userId") as? String
        let userLevel = ref.child("tour").child(userId!).child("level")
        userLevel.observeSingleEvent(of: .value, with: { (snapshot) in
            var level = snapshot.value as? Int
             print("inside showpopup level \(level)")
            self.checkLevel(userlevel: level ?? 0)
            
        })
        
        
    }
    
    func showView(userlevel: Int, levelstatus: Int){
        
        
    }
    
    func checkLevel(userlevel: Int){
        
         let lang = UserDefaults.standard.object(forKey: "lang") as? Int
         let userId = UserDefaults.standard.object(forKey: "userId") as? String
        
        var  leveluser = userlevel
        
        print("inside checklevel")
        
        ref = Database.database().reference()
        let userLevel = ref.child("levelstatus").child(userId!).child("level1")
        userLevel.observeSingleEvent(of: .value, with: { (snapshot) in
            var level1 = snapshot.value as? Int
               print("inside checklevel 11111 pre ")
            if (level1 == 0 && leveluser == 1){
                  print("inside checklevel11111")
                self.popupView.isHidden = false
                self.ref.child("levelstatus").child(self.userId!).updateChildValues(["level1": 1])
                if(lang == 0){
                self.levelText.text = "أتممت المرحلة الأولى"
                } else {
                    self.levelText.text = "Level 1 is complete!"
                }
                self.badgePopup.image = UIImage(named: self.badges[0])
            }
            
        })
        
        
        let userLevel2 = ref.child("levelstatus").child(userId!).child("level2")
        userLevel2.observeSingleEvent(of: .value, with: { (snapshot) in
            var level2 = snapshot.value as? Int
            if (level2 == 0 && leveluser == 2){
                     print("inside checkleve222222")
                self.popupView.isHidden = false
                self.ref.child("levelstatus").child(userId!).updateChildValues(["level2": 1])
                
                if(lang == 0){
                      self.levelText.text = "أتممت المرحلة الثانية"
                } else {
                    self.levelText.text = "Level 2 is complete!"
                }
                
              
                self.badgePopup.image = UIImage(named: self.badges[1])
            }
            
        })
        
        
        let userLevel3 = ref.child("levelstatus").child(userId!).child("level3")
        userLevel3.observeSingleEvent(of: .value, with: { (snapshot) in
            var level3 = snapshot.value as? Int
            if (level3 == 0 && leveluser==3){
                print("inside checkleve3333")
                self.popupView.isHidden = false
                self.ref.child("levelstatus").child(userId!).updateChildValues(["level3": 1])
                
                if(lang == 0){
                    self.levelText.text = "أتممت المرحلة الثالثة"
                } else {
                    self.levelText.text = "Level 3 is complete!"
                }
                
               
                self.badgePopup.image = UIImage(named: self.badges[2])
            }
            
        })
        
    
    
        
    }
    
    
    func saveScore(){
        
        ref = Database.database().reference();
        
        
        let userscore = ref.child("users").child(userId!).child("UserScore")
        userscore.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let score = snapshot.value as? String{
                let score1 = Int(score)
                var score2 = score1!+10
                var str = "\(score2)"
                self.ref.child("users").child(self.userId!).child("UserScore").setValue(str)
            }
        })
        
        
    }
    
    
    func displayBeacon() {
        //    for i in arrBeacon {
        //      print("value of array", arrBeacon[i])
        //     }
        
        print("inside displayBeacon 1")
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
            
            if q1==1 || q1==2 {
                self.arrBeacon.append(true)
            }
            else {
                self.arrBeacon.append(false)
            }
            if q2==1 || q2==2 {
                self.arrBeacon.append(true)
            }
            else {
                self.arrBeacon.append(false)
            }
            if q3==1 || q3==2 {
                self.arrBeacon.append(true)
            }
            else {
                self.arrBeacon.append(false)
            }
            if q4==1 || q4==2 {
                self.arrBeacon.append(true)
            }
            else {
                self.arrBeacon.append(false)
            }
            if q5==1 || q5==2 {
                self.arrBeacon.append(true)
            }
            else {
                self.arrBeacon.append(false)
            }
            if q6==1 || q6==2 {
                self.arrBeacon.append(true)
            }
            else {
                self.arrBeacon.append(false)
            }
            if q7==1 || q7==2 {
                self.arrBeacon.append(true)
            }
            else {
                self.arrBeacon.append(false)
            }
            if q8==1 || q8==2 {
                self.arrBeacon.append(true)
            }
            else {
                self.arrBeacon.append(false)
            }
            print("inside displayBeacon 2")
            self.temp = true
            
            
            self.Beacon()
        })
        
    }
    
    func Beacon() {
        var i = 0
        while i<arrBeacon.count {
            print(arrBeacon[i])
            i = i + 1
        }
        // setting Api
        let credentials = CloudCredentials(appID: "jawwab-s-your-own-app-lu3", appToken: "156e99a87189f9a6c4baf33f0268d425")
        
        self.proximityObserver = ProximityObserver(credentials: credentials, onError: { error in
            print("ProximityObserver error: \(error)")
        })
 /*
        let zoneMint = ProximityZone(tag: "Mint", range: ProximityRange(desiredMeanTriggerDistance: 2.0)!)
        if !self.arrBeacon[7] && self.arrBeacon[3]  && self.arrBeacon[4] && self.arrBeacon[1]  && self.arrBeacon[2] && self.arrBeacon[5] && self.arrBeacon[6] {
            zoneMint.onEnter = { contexts in
                print (" work!!")
                print ("Mint zone")
                
                self.sceneView.removeFromSuperview()
                
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let CompassViewController = storyBoard.instantiateViewController(withIdentifier: "compass") as! CompassViewController
                
                self.present(CompassViewController, animated: true, completion: nil)
            }
        }
       
        let zoneIce = ProximityZone(tag: "Ice", range: ProximityRange(desiredMeanTriggerDistance: 2.0)!)
 /*
        if  self.arrBeacon[3]  && !self.arrBeacon[4] {
            zoneIce.onEnter = { contexts in
                print ("Ice zone")
                self.flagIce2 = true
                // self.displayQObj()
                self.flagIce = true
                
                self.sceneView.removeFromSuperview()
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                if #available(iOS 11.3, *) {
                    let QuestViewController = storyBoard.instantiateViewController(withIdentifier: "questScene") as! QuestViewController
                    
                    self.present(QuestViewController, animated: false, completion: nil)
                } else {
                    // Fallback on earlier versions
                }
                
                
            }
        }  */
        let zoneBlueberry = ProximityZone(tag: "Blueberry", range: ProximityRange(desiredMeanTriggerDistance: 2.0)!)
        if  self.arrBeacon[1]  && self.arrBeacon[2] && !self.arrBeacon[3] {
            zoneBlueberry.onEnter = { contexts in
                print ("Ice zone")
                self.flagIce2 = true
                // self.displayQObj()
                self.flagIce = true
                
                self.sceneView.removeFromSuperview()
                self.selfie.isHidden = true
                self.profile.isHidden = true
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let PuzzleViewController = storyBoard.instantiateViewController(withIdentifier: "PuzzleStoryBoard") as! PuzzleViewController
                
                self.present(PuzzleViewController, animated: true, completion: nil)
                
                
            }
        }
        if  !self.arrBeacon[1]  && !self.arrBeacon[2] && !self.arrBeacon[3] {
            zoneBlueberry.onEnter = { contexts in
                print ("Blueberry zone")
                self.flagBlueBerry2 = true
                //     self.displayQObj()
                self.flagBlueBerry = true
                
                self.selfie.isHidden = true
                self.leaderboard.isHidden = true
                self.profile.isHidden = true
                self.mapIcon.isHidden = true
                self.rewardCoin.isHidden = true
                self.rewards.isHidden = true
                
                
                self.sceneView.removeFromSuperview()
                
                
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                 let CardChallangeViewController = storyBoard.instantiateViewController(withIdentifier: "cards") as! CardChallangeViewController
                 
                 self.present(CardChallangeViewController, animated: false, completion: nil)
 
               
            }
        }
        
        if  self.arrBeacon[1]  && !self.arrBeacon[2] && !self.arrBeacon[3] {
            zoneBlueberry.onEnter = { contexts in
                print ("Blueberry zone 2")
                self.flagBlueBerry2 = true
                //     self.displayQObj()
                self.flagBlueBerry = true
                
                self.selfie.isHidden = true
                self.leaderboard.isHidden = true
                self.profile.isHidden = true
                self.mapIcon.isHidden = true
                self.rewardCoin.isHidden = true
                self.rewards.isHidden = true
                
                
                self.sceneView.removeFromSuperview()
                
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let QuestionViewController = storyBoard.instantiateViewController(withIdentifier: "Questionscene") as! QuestionViewController
                
                self.present(QuestionViewController, animated: false, completion: nil)
 
                
               
              
                
            }
        }
        */
        
        
        //////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////
        let zonecouconet = ProximityZone(tag: "Coconut", range: ProximityRange(desiredMeanTriggerDistance: 2.0)!)
   /*     if   !self.arrBeacon[5] && !self.arrBeacon[6]  {
            zonecouconet.onEnter = { contexts in
                print ("Coconut zone")
                self.flagCoconut2 = true
                //  self.displayQObj()
                self.flagCoconut = true
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let SpaceViewController = storyBoard.instantiateViewController(withIdentifier: "SChallenge") as! SpaceViewController
                
                self.present(SpaceViewController, animated: false, completion: nil)
            }
        }
        if  self.arrBeacon[5] && !self.arrBeacon[6]  {
            zonecouconet.onEnter = { contexts in
                print ("Coconut zone 22")
                self.flagCoconut2 = true
                //  self.displayQObj()
                self.flagCoconut = true
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let MarksViewController = storyBoard.instantiateViewController(withIdentifier: "MarksStoryBoard") as! MarksViewController
                
                self.present(MarksViewController, animated: false, completion: nil)
            }
        }
        */
        //////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////
        
      if  !self.arrBeacon[4] && !self.arrBeacon[3]  {
            zonecouconet.onEnter = { contexts in
                print ("Ice zone")
                self.flagIce2 = true
                // self.displayQObj()
                self.flagIce = true
                
                self.sceneView.removeFromSuperview()
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                if #available(iOS 11.3, *) {
                    let QuestViewController = storyBoard.instantiateViewController(withIdentifier: "questScene") as! QuestViewController
                    
                    self.present(QuestViewController, animated: false, completion: nil)
                } else {
                    // Fallback on earlier versions
                }
                
                
            }
        }
        
        if  self.arrBeacon[4] && !self.arrBeacon[3] {
            zonecouconet.onEnter = { contexts in
                print ("Ice zone")
                self.flagIce2 = true
                // self.displayQObj()
                self.flagIce = true
                
                self.sceneView.removeFromSuperview()
                self.selfie.isHidden = true
                self.profile.isHidden = true
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let PuzzleViewController = storyBoard.instantiateViewController(withIdentifier: "PuzzleStoryBoard") as! PuzzleViewController
                
                self.present(PuzzleViewController, animated: true, completion: nil)
                
                
            }
        }
         self.proximityObserver.startObserving([zonecouconet])
       // self.proximityObserver.startObserving([zoneMint, zoneIce, zoneBlueberry, zonecouconet])
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
        DispatchQueue.main.async {
       
        super.viewDidLoad()
           let lang = UserDefaults.standard.object(forKey: "lang") as? Int
        
            self.popupView.isHidden = true
            self.ShowPopup()
        print("in QUESTION 1")
       self.view.addSubview(self.sceneView)
        
        //add autolayout contstraints
        self.sceneView.translatesAutoresizingMaskIntoConstraints = false
        self.sceneView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.sceneView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.sceneView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.view.sendSubviewToBack(self.sceneView)
   
        
        self.EndUserSession()
        
        
        
        /// Display user score
        self.updateRewards()
        // beacon
        self.displayBeacon()
        self.EndUserSession()
        
        
        }
    }
    
    let configuration = ARWorldTrackingConfiguration()
    
    func session(_ session: ARSession, didFailWithError error: Error) {
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
    
    @IBAction func closeLevel(_ sender: Any) {
        
    popupView.removeFromSuperview()
    }
    
    func restartSessionWithoutDelete() {
        // Restart session with a different worldAlignment - prevents bug from crashing app
    //    self.sceneView.session.pause()
        
//        self.sceneView.session.run(configuration, options: [
//            .resetTracking,
//            .removeExistingAnchors])
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        
    //   sceneView.session.run(configuration)
        
    }
    
    
/*    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     //   sceneView.session.pause()
    }
    */
   
    
    
    
}
