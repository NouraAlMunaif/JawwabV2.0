//
//  QuestViewController.swift
//  Jawwab
//
//  Created by Noura Almunaif on 28/01/2019.
//  Copyright © 2019 atheer. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import EstimoteProximitySDK
import Firebase

// For generating random numbers


@available(iOS 11.3, *)
class QuestViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var done: UIButton!
    var player: AVAudioPlayer?
    var proximityObserver: ProximityObserver! // Beacon declaration
    var ref: DatabaseReference!
    let userId = UserDefaults.standard.object(forKey: "userId") as? String
    //@IBOutlet weak var sceneView: ARSCNView!
    let sceneView = ARSCNView()
    
    @IBOutlet weak var leaderboard: UIButton!
    @IBOutlet weak var map: UIButton!
    @IBOutlet weak var rewarsIcon: UIButton!
    
    //  @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var label: UIImageView!
    @IBOutlet weak var reward: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var popuplabel: UILabel!
    
    
    let fadeDuration: TimeInterval = 0.3
    let rotateDuration: TimeInterval = 3
    let waitDuration: TimeInterval = 0.5
    
    lazy var fadeAndSpinAction: SCNAction = {
        return .sequence([
            .fadeIn(duration: fadeDuration),
            .rotateBy(x: 0, y: 0, z: CGFloat.pi * 360 / 180, duration: rotateDuration),
            .wait(duration: waitDuration)
            // .fadeOut(duration: fadeDuration)
            ])
    }()
    
    lazy var fadeAction: SCNAction = {
        return .sequence([
            .fadeOpacity(by: 0.8, duration: fadeDuration),
            .wait(duration: waitDuration),
            //   .fadeOut(duration: fadeDuration)
            ])
    }()
    
    
    lazy var bookNode: SCNNode = {
        guard let scene = SCNScene(named: "art.scnassets/book.scn"),
            let node = scene.rootNode.childNode(withName: "book", recursively: false) else { return SCNNode() }
        let scaleFactor  = 0.1
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        return node
    }()
    
    
    func createLineNode(fromPos origin: SCNVector3, toPos destination: SCNVector3, color: UIColor) -> SCNNode {
        let line = lineFrom(vector: origin, toVector: destination)
        let lineNode = SCNNode(geometry: line)
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = color
        line.materials = [planeMaterial]
        
        return lineNode
    }
    
    func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]
        
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        
        return SCNGeometry(sources: [source], elements: [element])
    }
    
    
    func highlightNode(_ node: SCNNode) {
        let (min, max) = node.boundingBox
        let zCoord = node.position.z
        let topLeft = SCNVector3Make(min.x, max.y, zCoord)
        let bottomLeft = SCNVector3Make(min.x, min.y, zCoord)
        let topRight = SCNVector3Make(max.x, max.y, zCoord)
        let bottomRight = SCNVector3Make(max.x, min.y, zCoord)
        
        
        let bottomSide = createLineNode(fromPos: bottomLeft, toPos: bottomRight, color: .yellow)
        let leftSide = createLineNode(fromPos: bottomLeft, toPos: topLeft, color: .yellow)
        let rightSide = createLineNode(fromPos: bottomRight, toPos: topRight, color: .yellow)
        let topSide = createLineNode(fromPos: topLeft, toPos: topRight, color: .yellow)
        
        [bottomSide, leftSide, rightSide, topSide].forEach {
            //   $0.name = kHighlightingNode // Whatever name you want so you can unhighlight later if needed
            node.addChildNode($0)
        }
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
    
    
    
    
    
    @IBAction func skipButton(_ sender: Any) {
        solveChallange(q: 5, status: 2)
        setCurrent(q: 5)
        text.removeFromSuperview()
        label.removeFromSuperview()
        skipBtn.removeFromSuperview()
        reward.removeFromSuperview()
        leaderboard.removeFromSuperview()
        map.removeFromSuperview()
        rewarsIcon.removeFromSuperview()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let skipViewController = storyBoard.instantiateViewController(withIdentifier: "skip") as! skipViewController
        
        self.present(skipViewController, animated: false, completion: nil)
        
    }
    
    override func viewDidLoad() {  DispatchQueue.main.async {
        super.viewDidLoad()
        
          let lang = UserDefaults.standard.object(forKey: "lang") as? Int
        
        if (lang == 1){
              self.skipBtn.setBackgroundImage(UIImage(named: "engnext"), for: UIControl.State.normal)
            self.popuplabel.text = "Information"
            self.text.text = "Look for the hidden book"
        }
        
        
        
        self.view.addSubview(self.sceneView)
        
        //add autolayout contstraints
        self.sceneView.translatesAutoresizingMaskIntoConstraints = false
        self.sceneView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.sceneView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.sceneView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.view.sendSubviewToBack(self.sceneView)
        //   label.layer.backgroundColor  = UIColor.white.cgColor
        self.label.layer.masksToBounds = true
        self.label.layer.cornerRadius = 15
        
        self.playSound(fileName: "popUp")
        
        self.sceneView.delegate = self as ARSCNViewDelegate
        self.configureLighting()
        self.view1.isHidden = true
           self.updateRewards()
        /*       let estimoteCloudCredentials = CloudCredentials(appID: "reem-badr-s-proximity-for--6o4", appToken: "8be2dff5dc16b9747b7fafe97ff53708")
         
         self.proximityObserver = ProximityObserver(credentials: estimoteCloudCredentials, onError: { error in
         print("ProximityObserver error: \(error)")
         
         
         })
         
         let zone = ProximityZone(tag: "reem-badr-s-proximity-for--6o4", range: ProximityRange.near)
         zone.onExit = { contexts in
         print("Exit in quest view controller")
         
         let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let Question1ViewController = storyBoard.instantiateViewController(withIdentifier: "mainView") as! Question1ViewController
         
         self.present(Question1ViewController, animated: true, completion: nil)
         }
         
         self.proximityObserver.startObserving([zone]) */
        
        self.EndUserSession()
        
        
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
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetTrackingConfiguration()
    }
    
    //   override func viewWillDisappear(_ animated: Bool) {
    //       super.viewWillDisappear(animated)
    //       sceneView.session.pause()
    //   }
    
    
    func resetTrackingConfiguration() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
            else {
                print("No image detected");
                return }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as! UITouch
        if(touch.view == self.sceneView){
            print("touch working")
            let viewTouchLocation:CGPoint = touch.location(in: sceneView)
            guard let result = sceneView.hitTest(viewTouchLocation, options: nil).first else {
                return
            }
            //   let imageName = imageAnchor.referenceImage.name
            if #available(iOS 12.0, *) {
                let overlayNode = self.getNode(withImageName: "Book")
           
            if (overlayNode.contains(result.node)) { //to ensure which 3d object was touched
                print("match")
                // add a tap gesture recognizer
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                sceneView.addGestureRecognizer(tapGesture)
                
                //   for view in self.view.subviews {
                text.removeFromSuperview()
                label.removeFromSuperview()
                skipBtn.removeFromSuperview()
                overlayNode.removeFromParentNode()
                //   }*/
                solveChallange(q: 5, status: 1)
                setCurrent(q: 5)
                
                self.view1.isHidden = false
                
                
            }
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    
    @IBAction func done(_ sender: Any) {
        view1.removeFromSuperview()
        reward.removeFromSuperview()
        leaderboard.removeFromSuperview()
        map.removeFromSuperview()
        rewarsIcon.removeFromSuperview()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let SuccessMessagesViewController = storyBoard.instantiateViewController(withIdentifier: "QMessage") as! SuccessMessagesViewController
        self.present(SuccessMessagesViewController, animated: true, completion: nil)
    }
    
    
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
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
            
            material.emission.contents = UIColor.red
            
            
            SCNTransaction.commit()
        }
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
         //   self.saveScore()
           // self.updateRewards()
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
}

@available(iOS 11.3, *)
extension QuestViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            guard let imageAnchor = anchor as? ARImageAnchor,
                let imageName = imageAnchor.referenceImage.name else { return }
            ("image detected")
            let overlayNode = self.getNode(withImageName: imageName)
            overlayNode.opacity = 0
            overlayNode.position.y = 0.2
            overlayNode.runAction(self.fadeAndSpinAction)
            node.addChildNode(overlayNode)
            
        }
    }
    
    
    
    
    func getPlaneNode(withReferenceImage image: ARReferenceImage) -> SCNNode {
        let plane = SCNPlane(width: image.physicalSize.width,
                             height: image.physicalSize.height)
        let node = SCNNode(geometry: plane)
        return node
    }
    
    func getNode(withImageName name: String) -> SCNNode {
        var node = SCNNode()
        switch name {
        case "Book":
            node = bookNode
        default:
            break
        }
        return node
    }
    
    
    
}

