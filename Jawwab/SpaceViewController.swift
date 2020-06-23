//
//  SpaceChallengeViewController.swift
//  Jawwab
//
//  Created by Nora AlMunaif on 21/03/2019.
//  Copyright © 2019 atheer. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import EstimoteProximitySDK
import Firebase
class SpaceViewController: UIViewController, ARSCNViewDelegate  {
    
    let sceneView = ARSCNView()
    
    @IBOutlet weak var popuptext: UILabel!
    @IBOutlet weak var nextbttn: UIButton!
    @IBOutlet weak var planetsbox: UIImageView!
    
   
    var player: AVAudioPlayer?
    var ref: DatabaseReference!
    let userId = UserDefaults.standard.object(forKey: "userId") as? String
    let lang = UserDefaults.standard.object(forKey: "lang") as? Int
    @IBOutlet weak var reward: UILabel!
    var node1: SCNNode? = nil
    var node2: SCNNode? = nil
    var initialValue: Float = 0.0
    
    @IBOutlet weak var map: UIButton!
    @IBOutlet weak var popup: UIView!
    @IBOutlet weak var leaderboard: UIButton!
    
    @IBOutlet weak var rewardsIcon: UIButton!
    
    @IBOutlet weak var skipBtn: UIButton!
    
    @IBOutlet weak var spaceCounter: UILabel!
    
    @IBOutlet weak var telescop: UIImageView!
    @IBOutlet weak var counter: UIImageView!
    
    
   
    var earth: Bool = false
    var moon: Bool = false
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
    
  //  @IBOutletco weak var spaceCounter: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.EndUserSession()
        if (lang == 1){
            popuptext.text = "Use the telescope to explore planets that will appear in the next challenge"
            nextbttn.setBackgroundImage(UIImage(named: "engnext"), for: UIControl.State.normal)
            planetsbox.image = UIImage(named:"PlanetsCounter.png")
        }
        self.view.addSubview(self.sceneView)
        
        //add autolayout contstraints
        self.sceneView.translatesAutoresizingMaskIntoConstraints = false
        self.sceneView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.sceneView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.sceneView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.view.sendSubviewToBack(self.sceneView)
        
        
        spaceCounter.isHidden = true
        counter.isHidden = true
        telescop.isHidden = true
     //   self.playSound(fileName: "popUp")
        self.updateRewards()
       
        self.sceneView.delegate = self as! ARSCNViewDelegate
        
        
        self.configureLighting()
        
        self.displaySpace()
    }
    
    func displaySpace(){
        // Set the view's delegate
        sceneView.delegate = self
        
        
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        //      let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
        let sphere1 = SCNSphere(radius: 0.2)
        let sphere2 = SCNSphere(radius: 0.2)
        
        let material1 = SCNMaterial()
        let material2 = SCNMaterial()
        
        material1.diffuse.contents = UIImage(named: "art.scnassets/earth.jpg")!
        material2.diffuse.contents = UIImage(named: "art.scnassets/moon.jpg")!
        
        sphere1.materials = [material1]
        sphere2.materials = [material2]
        
        node1 = SCNNode()
        node2 = SCNNode()
        
        let camera = SCNNode()
        camera.name = "cameraNode"
        camera.camera = SCNCamera()
        let dir = self.calculateCameraDirection(cameraNode: camera)
        let pos1 = self.pointInFrontOfPoint(point: camera.position, direction:dir, distance: 0.4)
        let pos2 = self.pointInFrontOfPoint(point: camera.position, direction:dir, distance: 0.4)
        
        
        node1!.position = pos1
        node2!.position = pos2
        
        node1!.geometry = sphere1
        node2!.geometry = sphere2
        
        sceneView.scene.rootNode.addChildNode(node1!)
        sceneView.scene.rootNode.addChildNode(node2!)
        sceneView.autoenablesDefaultLighting = true
        
        
    }
    
    func pointInFrontOfPoint(point: SCNVector3, direction: SCNVector3, distance: Float) -> SCNVector3 {
        var x = Float()
        var y = Float()
        var z = Float()
        var numX1 = Float.random(in: -3 ... -1.5)
        var numX2 = Float.random(in: 1.5 ... 3)
        
        while self.initialValue == numX1 + 1 || self.initialValue == numX2 - 1 {
            numX1 = Float.random(in: -3 ... -1.5)
            numX2 = Float.random(in: 1.5 ... 3)
        }
        
        let numXBoll = Bool.random()
        let numY = Float.random(in: 0 ... 0.5)
        
        if numXBoll {
            x = point.x + distance * direction.x + numX1
        }
        else {
            x = point.x + distance * direction.x + numX2
        }
        self.initialValue = x
        print ("x: ",x)
        y = point.y + distance * direction.y + numY
        print ("y: ",y)
        z = point.z + distance * direction.z
        print ("z: ",z)
        
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
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as! UITouch
        if(touch.view == self.sceneView){
            print("touch working")
            let viewTouchLocation:CGPoint = touch.location(in: sceneView)
            guard let result = sceneView.hitTest(viewTouchLocation, options: nil).first else {
                return
            }
            
            
            if (self.node1!.contains(result.node)) { //to ensure which 3d object was touched
                print("match node 1")
                // add a tap gesture recognizer
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                sceneView.addGestureRecognizer(tapGesture)
                
                earth = true
                
                
                if ( earth && moon ){
                    spaceCounter.text = "2/2"
                    self.solveChallange(q: 6, status: 1)
                    self.setCurrent(q: 6)
                    if node1 != nil {
                        print ("node1 is not nil ")
                    }
                    if node2 != nil {
                        print ("node2 is not nil ")
                    }
                    if planetsbox != nil {
                        print ("planetsbox is not nil ")
                    }
                    if map != nil {
                        print ("map is not nil ")
                    }
                    if popup != nil {
                        print ("popup is not nil ")
                    }
                    if leaderboard != nil {
                        print ("leaderboard is not nil ")
                    }
                    if rewardsIcon != nil {
                        print ("rewardsIcon is not nil ")
                    }
                    if skipBtn != nil {
                        print ("skipBtn is not nil ")
                    }
                    if spaceCounter != nil {
                        print ("spaceCounter is not nil ")
                    }
                    if telescop != nil {
                        print ("telescop is not nil ")
                    }
                    if counter != nil {
                        print ("counter is not nil ")
                    }
                    if reward != nil {
                        print ("reward is not nil ")
                    }
             //       reward.removeFromSuperview()
                  reward.isHidden = true
                   node1?.removeFromParentNode()
                     node2?.removeFromParentNode()
                 planetsbox.removeFromSuperview()
                     map.removeFromSuperview()
                    popup.removeFromSuperview()
                    leaderboard.removeFromSuperview()
                    rewardsIcon.removeFromSuperview()
                    skipBtn.removeFromSuperview()
                    spaceCounter.removeFromSuperview()
                    telescop.removeFromSuperview()
                    counter.removeFromSuperview()
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let SpaceChallangePopupViewController = storyBoard.instantiateViewController(withIdentifier: "SpaceMsg") as! SpaceChallangePopupViewController
                    
                    self.present(SpaceChallangePopupViewController, animated: false, completion: nil)
                }
                else {
                    spaceCounter.text = "1/2"
                }
                
                
                
            }
            if (self.node2!.contains(result.node)) { //to ensure which 3d object was touched
                print("match node 2")
                // add a tap gesture recognizer
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                sceneView.addGestureRecognizer(tapGesture)
                moon = true
                
                
                
                if ( earth && moon ){
                    spaceCounter.text = "2/2"
                    self.solveChallange(q: 6, status: 1)
                    self.setCurrent(q: 6)
                    if node1 != nil {
                        print ("node1 is not nil ")
                    }
                    if node2 != nil {
                        print ("node2 is not nil ")
                    }
                    if planetsbox != nil {
                        print ("planetsbox is not nil ")
                    }
                    if map != nil {
                        print ("map is not nil ")
                    }
                    if popup != nil {
                        print ("popup is not nil ")
                    }
                    if leaderboard != nil {
                        print ("leaderboard is not nil ")
                    }
                    if rewardsIcon != nil {
                        print ("rewardsIcon is not nil ")
                    }
                    if skipBtn != nil {
                        print ("skipBtn is not nil ")
                    }
                    if spaceCounter != nil {
                        print ("spaceCounter is not nil ")
                    }
                    if telescop != nil {
                        print ("telescop is not nil ")
                    }
                    if counter != nil {
                        print ("counter is not nil ")
                    }
                    if reward != nil {
                        print ("reward is not nil ")
                    }
               //     reward.removeFromSuperview()
                    node1?.removeFromParentNode()
                   node2?.removeFromParentNode()
               /*     spaceCounter.removeFromSuperview()
                    popup.removeFromSuperview()
                    telescop.removeFromSuperview()
                    counter.removeFromSuperview()
                    sceneView.removeFromSuperview()
                    self.node1!.removeFromParentNode()
                    self.node2!.removeFromParentNode() */
                     reward.isHidden = true
                  planetsbox.removeFromSuperview()
                      map.removeFromSuperview()
                    popup.removeFromSuperview()
                   leaderboard.removeFromSuperview()
                    rewardsIcon.removeFromSuperview()
                    skipBtn.removeFromSuperview()
                     spaceCounter.removeFromSuperview()
                    telescop.removeFromSuperview()
                     counter.removeFromSuperview()
                 
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let SpaceChallangePopupViewController = storyBoard.instantiateViewController(withIdentifier: "SpaceMsg") as! SpaceChallangePopupViewController
                    
                    self.present(SpaceChallangePopupViewController, animated: false, completion: nil)
                }
                else {
                  spaceCounter.text = "1/2"
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func skipBtn(_ sender: Any) {
        solveChallange(q: 6, status: 2)
        setCurrent(q: 6)
        reward.isHidden = true
        node1?.removeFromParentNode()
        node2?.removeFromParentNode()
        planetsbox.removeFromSuperview()
        map.removeFromSuperview()
        popup.removeFromSuperview()
        leaderboard.removeFromSuperview()
        rewardsIcon.removeFromSuperview()
        skipBtn.removeFromSuperview()
        spaceCounter.removeFromSuperview()
        telescop.removeFromSuperview()
        counter.removeFromSuperview()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let skipViewController = storyBoard.instantiateViewController(withIdentifier: "skip") as! skipViewController
        
        self.present(skipViewController, animated: false, completion: nil)
    }
    
    func initChallange(q: Int){
        ref = Database.database().reference();
        var userId = UserDefaults.standard.object(forKey: "userId") as? String
        // 0 ==> not solved  || 1 ==> solved
        self.ref.child("tour").child(userId!).child("q\(q)").setValue(0)
        
    }
    

    func solveChallange(q: Int, status: Int){
        ref = Database.database().reference()
        var userId = UserDefaults.standard.object(forKey: "userId") as? String
        // 0 ==> not solved  // 1 ==> solved
        self.ref.child("tour").child(userId!).updateChildValues(["q\(q)": status])
        if (status == 1) {
          //  self.saveScore()
        //    self.updateRewards()
        }
    }
    
    func setCurrent(q: Int){
        ref = Database.database().reference()
        var userId = UserDefaults.standard.object(forKey: "userId") as? String
        self.ref.child("tour").child(userId!).updateChildValues(["current": q])
        
    }
    
    
    func updateRewards(){
        
        ref = Database.database().reference()
        
        let userscore = ref.child("users").child(userId!).child("UserScore")
        userscore.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let score = snapshot.value as? String{
                let score1 = Int(score)
                
                self.passingScore(score1: score1!)
            }
        })}
    
    
    func passingScore(score1: Int){
        reward.text = "\(score1)"
    }
    
    
    
    func saveScore(){
        
        ref = Database.database().reference();
        
        
        let userscore = ref.child("users").child(userId!).child("UserScore")
        userscore.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let score = snapshot.value as? String{
                let score1 = Int(score)
                var score2 = score1!+10
                self.ref.child("users").child(self.userId!).child("UserScore").setValue("\(score2)")
            }
        })
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    
  
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        //   let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: sceneView)
        let hitResults = sceneView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.gray
            
            
            SCNTransaction.commit()
        }
    }
    
    
    @IBAction func showChallange(_ sender: Any) {
        
         spaceCounter.isHidden = false
        popup.isHidden = true
        telescop.isHidden = false
        counter.isHidden = false
        
    }
    
  
    
    
    
}
