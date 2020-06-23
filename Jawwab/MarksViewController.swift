//
//  MarksViewController.swift
//  Jawwab
//
//  Created by Nora Almunaif on 05/06/1440 AH.
//  Copyright © 1440 atheer. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Firebase
import EstimoteProximitySDK

class MarksViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var skipbttn: UIButton!
    
    @IBOutlet weak var rewardsIcon: UIButton!
    let userId = UserDefaults.standard.object(forKey: "userId") as? String
    let lang = UserDefaults.standard.object(forKey: "lang") as? Int
    
    @IBOutlet weak var leaderBoard: UIButton!
    @IBOutlet weak var mapIcon: UIButton!
    var Marks = [String]()
    var x : Float = 1
    var y : Float = 1
    //   @IBOutlet weak var sceneView: ARSCNView!
    let sceneView = ARSCNView()
    var proximityObserver: ProximityObserver!

    @IBOutlet weak var msg1: UITextField!
    var counter = 0
 //   @IBOutlet weak var reward: UILabel!
    @IBOutlet weak var sendIcon: UIButton!
    var final: Bool = false
    var final2: Bool = false
    //  var final3: Bool = false
    var lastPosition: Float = 0
    var position: Float = 0
    var position2: Float = 0
    var lastPosition2: Float = 0
    let fadeDuration: TimeInterval = 0.3
    let rotateDuration: TimeInterval = 3
    let waitDuration: TimeInterval = 0.5
    var ref: DatabaseReference!
    var flaggedNode = [SCNNode]()
    var flaggedtext = [SCNText]()
    var flaggedDescription = [String]()
    var key = [String]()
    var clicked = [Bool]()
    var max: Bool = false
    var flagCounter = 0
    var flagN = 0
    var i = 0
    var n = 0
    private var addedNode: SCNNode?
    private var imageNode: SCNNode?
    private var animationInfo: AnimationInfo?
    
    @IBOutlet weak var rewards: UILabel!
    
    
    @IBOutlet weak var insicon: UIImageView!
    @IBOutlet weak var instext: UILabel!
    @IBOutlet weak var insbutten: UIButton!
    @IBOutlet weak var inspopup: UIImageView!
    
    
    //   var obj = [flagMark]()
    
    lazy var fadeAndSpinAction: SCNAction = {
        return .sequence([
            .fadeIn(duration: fadeDuration),
            .rotateBy(x: 0, y: 0, z: 0, duration: rotateDuration),
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
    
    
    
    
    
    
    @IBAction func addMark(_ sender: Any) {
        print("enter click")
        
        if(msg1.text?.isEmpty == false){
            if (msg1.text != "") {
                
                
                
                ref = Database.database().reference();
                let markID = Database.database().reference().childByAutoId().key
                //     ref.child("Marks").child(markID).child("name").setValue("passing variable")
                ref.child("Marks").child(markID!).child("text").setValue(self.msg1.text)
                ref.child("Marks").child(markID!).child("flag").setValue(0)
                ref.child("Marks").child(markID!).child("markID").setValue(markID)
                print("marks added successfully ")
                
                
                
                //   self.Marks.append(markID)
                self.key.append(markID!)
                self.clicked.append(false)
                self.Marks.append(self.msg1.text!)
                self.i = self.i + 1
                print ("i: ", i)
                let j = i - 1
                let node = self.getMark(withIndex: j)
                self.addedNode = node
                final = true
                final2 = true
                // self.sceneView.scene.rootNode.addChildNode(node)
                //  self.sceneView.autoenablesDefaultLighting = true
                
                //         self.msg1.text = ""
                self.msg1.isHidden = true
                self.sendIcon.isHidden = true
             //   self.msg1.removeFromSuperview()
               // self.sendIcon.removeFromSuperview()
                
            }
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
            
            
            let location = touch.location(in: self.view)
            print(location)
            
            if (flaggedNode.contains(result.node)) {
                print(result.node.description)
                var v = 0
                var flag = 0
                var temp = false
                if !temp {
                    while v<flaggedDescription.count {
                        flagN = 0
                        flag = 0
                        if (flaggedDescription[v].isEqual(result.node.description)) {
                            print("match")
                            flagN = 0
                            flag = 0
                            if !clicked[v] {
                                print ("before: ", flagN)
                                ref = Database.database().reference();
                                let index = v
                                let mark = self.ref.child("Marks").child(key[v]);
                                mark.observe(DataEventType.value, with: { (snapshot) in
                                    if !snapshot.exists() {
                                        print ("error")
                                        return
                                    }
                                    let postDict = snapshot.value as? [String : AnyObject]
                                    flag = postDict?["flag"] as! Int
                                    self.flagN = flag
                                    print ("inside: ", flag)
                                    print ("flag: ", flag)
                                    self.flagN = flag
                                    if !temp && !self.clicked[index]{
                                        self.clicked[index] = true
                                        self.flaggedMark(numOfFlagged: self.flagN+1, index: index)
                                    }
                                    temp = true
                                    print ("temp = true")
                                    
                                })
                                
                            }
                        }
                        
                        v = v + 1
                    }
                }
                
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                sceneView.addGestureRecognizer(tapGesture)
                
                
            }
            
            print ("outside")
            
        }
        
    }
    
    
    func flaggedMark(numOfFlagged: Int, index: Int){
        ref = Database.database().reference();
        print("after: ", flagN)
        if numOfFlagged == 3 {
            ref.child("Marks").child(key[index]).removeValue()
        }
            
        else{
            ref.child("Marks").child(key[index]).child("flag").setValue(numOfFlagged)
        }
    }
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        
        let p = gestureRecognize.location(in: sceneView)
        let hitResults = sceneView.hitTest(p, options: [:])
        
        if hitResults.count > 0 {
            
            let result = hitResults[0]
            
            let material = result.node.geometry!.firstMaterial!
            
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                var v = 0
                while v<self.flaggedDescription.count {
                    
                    if (self.flaggedDescription[v].isEqual(result.node.description)) {
                        material.emission.contents = UIColor.red
                    }
                    v = v + 1
                }
                SCNTransaction.commit()
            }
            
            
            
            SCNTransaction.commit()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.unicodeScalars.count + string.unicodeScalars.count - range.length
        max = true
        if (count >= 51){
            msg1.layer.borderColor = UIColor.red.cgColor
            msg1.layer.borderWidth = 2.0;
        }
        return count <= 51
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if(lang == 1){
            msg1.placeholder = "Leave a comment"
            skipbttn .setBackgroundImage(UIImage(named: "Skipchalangeeng"), for: UIControl.State.normal)
            instext.text = "Share an information and discover other people ideas"
            insbutten.setBackgroundImage(UIImage(named: "engnext"), for: UIControl.State.normal)
            
        }
        
        self.view.addSubview(self.sceneView)
        
        //add autolayout contstraints
        self.sceneView.translatesAutoresizingMaskIntoConstraints = false
        self.sceneView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.sceneView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.sceneView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.view.sendSubviewToBack(self.sceneView)
        //   self.sceneView.delegate = self as? ARSCNViewDelegate
        self.sceneView.delegate = self as ARSCNViewDelegate
        self.view.bringSubviewToFront(sendIcon)
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKey))
         self.updateRewards()
        view.addGestureRecognizer(tap)
        
        msg1.delegate = self
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        solveChallange(q: 7, status: 1)
        setCurrent(q: 7)
        sceneView.showsStatistics = false
        
        
        self.configureLighting()
        
        /*    let credentials = CloudCredentials(appID: "jawwab-s-your-own-app-lu3", appToken: "156e99a87189f9a6c4baf33f0268d425")
         
         self.proximityObserver = ProximityObserver(credentials: credentials, onError: { error in
         print("ProximityObserver error: \(error)")
         })
         
         
         let zonecouconet = ProximityZone(tag: "Coconut", range: ProximityRange(desiredMeanTriggerDistance: 1.0)!)
         zonecouconet.onExit = { contexts in
         print ("Exit from Coconut")
         self.dismiss(animated: true)
         
         }
         
         self.proximityObserver.startObserving([zonecouconet])*/
        
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
    
    @IBAction func skip(_ sender: Any) {
  
        rewardsIcon.removeFromSuperview()
        msg1.removeFromSuperview()
        sendIcon.removeFromSuperview()
        mapIcon.removeFromSuperview()
        leaderBoard.removeFromSuperview()
        rewards.removeFromSuperview()
        skipbttn.removeFromSuperview()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let skipViewController = storyBoard.instantiateViewController(withIdentifier: "skip") as! skipViewController
        
        self.present(skipViewController, animated: false, completion: nil)
        
     }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    @objc func DismissKey(){
        view.endEditing(true)
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetTrackingConfiguration()
    }
    
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
    
    func solveChallange(q: Int, status: Int){
        ref = Database.database().reference()
        var userId = UserDefaults.standard.object(forKey: "userId") as? String
        // 0 ==> not solved  // 1 ==> solved
        self.ref.child("tour").child(userId!).updateChildValues(["q\(q)": status])
        if (status == 1) {
      //      self.saveScore()
          self.updateRewards()
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
        rewards.text = "\(score1)"
    }
    
    
    
    @IBAction func next(_ sender: Any) {
        
        var w1 = "بإمكانك التبليغ على المشاركات المسيئة بالضغط على هذه الإيقونة"
        if(lang==1){
            w1 = "You can report inappropriate comments by clicking this icon"
        }
        counter = counter + 1
        switch counter {
        case 1:
            insicon.image = UIImage(named:"flag.png")
            instext.text = w1
        case 2:
            insicon.isHidden = true
            instext.isHidden = true
            inspopup.isHidden = true
            insbutten.isHidden = true
        default:
            print("idk")
        }
        
        
        
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
extension MarksViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            guard anchor is ARImageAnchor else {
                return
            }
            
            self.ref = Database.database().reference()
            var marks = [String]()
            var k = [String]()
            var temp = false
            self.n = 0
            self.ref.child("Marks").observeSingleEvent(of: .value, with: { (snapshot) in
                if let result = snapshot.children.allObjects as? [DataSnapshot] {
                    marks.removeAll()
                    print ("array of marks: ", marks.count)
                    self.n=0
                    for child in result {
                        let snapshotValue = child.value as? NSDictionary
                        var text2 = snapshotValue?["text"] as? String
                        let ID = snapshotValue?["markID"] as? String
                        text2 = text2! + " "
                        k.append(ID!)
                        marks.append(text2!)
                        k[self.n] = (ID!)
                        marks[self.n] = (text2!)
                        
                        temp = false
                        print (text2!)
                        
                        var text = SCNText(string: text2, extrusionDepth: 0)
                        let material = SCNMaterial()
                        material.diffuse.contents = UIColor.black
                        text.materials = [material]
                        text.font = UIFont(name: "FFHekaya-Light", size: 15)
                        
                        let node2 = SCNNode()
                        
                        self.x = 1.25 + self.x
                        print ("X: ", self.x)
                        node2.position = SCNVector3(0, self.x/60 , 0)
                        
                        /*     if (self.n == 0){
                         node2.position = SCNVector3(0, self.x/60 , 0)
                         //          print ("lastPosition 1: ", self.lastPosition)
                         }
                         else if (self.n%3 == 0){
                         self.x = 1 + self.x
                         node2.position = SCNVector3(0, self.x/60 , 0)
                         //        print ("lastPosition 2: ", self.lastPosition)
                         
                         }
                         else if (self.n%3 == 1){
                         var h = (self.lastPosition) / 7000 + 0.059267633
                         node2.position = SCNVector3(h , self.x/60 , 0)
                         //         print ("lastPosition 3: ", self.lastPosition , "        INSIDE IF ", node2.boundingBox.min.x, "  h: ", h )
                         //  self.lastPosition = h + self.lastPosition
                         
                         } else {
                         var h = (self.lastPosition) / 7000 + 0.109267633
                         node2.position = SCNVector3(h , self.x/60 , 0)
                         print ("lastPosition 4: ", self.lastPosition , "        INSIDE IF ", node2.boundingBox.min.x, "  h: ", h )
                         self.lastPosition = 0
                         }
                         */
                        //    print ("lastPosition ff: ", self.lastPosition)
                        node2.scale = SCNVector3(0.001, 0.001, 0.001)
                        node2.geometry = text
                        text = node2.geometry as! SCNText
                        
                        let minVec = node2.boundingBox.min
                        let maxVec = node2.boundingBox.max
                        let bound = SCNVector3Make(maxVec.x - minVec.x,
                                                   maxVec.y - minVec.y,
                                                   maxVec.z - minVec.z);
                        node2.pivot = SCNMatrix4MakeTranslation(bound.x / 2,
                                                                bound.y / 2,
                                                                bound.z / 2)
                        
                        
                        let image = UIImage(named: "flag")
                        let planeNode4 = SCNNode(geometry: SCNPlane(width: 15, height: 15))
                        planeNode4.geometry?.firstMaterial?.diffuse.contents = image
                        planeNode4.position = SCNVector3(-4 , 7, 0)
                        
                        let plane = SCNPlane(width: CGFloat(bound.x + 37),
                                             height: CGFloat(bound.y + 3))
                        plane.cornerRadius = 5
                        plane.firstMaterial?.diffuse.contents = UIColor.gray.withAlphaComponent(0.75)
                        
                        
                        let planeNode = SCNNode(geometry: plane)
                        planeNode.position = SCNVector3(CGFloat( minVec.x  ) + CGFloat(bound.x ) / 2 ,
                                                        CGFloat( minVec.y ) + CGFloat(bound.y ) / 2,CGFloat(minVec.z - 0.01))
                        
                        
                        
                        //     node2.__getBoundingB
                        self.lastPosition = node2.boundingBox.min.x + self.lastPosition + 0.059267633
                        //    self.lastPosition = node2.presentation.position.x
                        print ("lastPosition: ",self.lastPosition)
                        print ("node2.boundingBox.min.x: ",node2.boundingBox.min.x)
                        print ("bound.x: ",bound.x)
                        self.lastPosition2 = bound.x
                        
                        node2.addChildNode(planeNode)
                        node2.addChildNode(planeNode4)
                        planeNode.name = "text"
                        
                        
                        self.flaggedDescription.append(planeNode4.description)
                        
                        self.flaggedNode.append(planeNode4)
                        self.flagCounter = self.flagCounter + 1
                        let lookAtConstraint = SCNBillboardConstraint()
                        node.constraints = [lookAtConstraint]
                        node.addChildNode(node2)
                        self.sceneView.scene.rootNode.addChildNode(node)
                        self.sceneView.autoenablesDefaultLighting = true
                        self.i = self.i + 1
                        self.n = self.n + 1
                    }
                    var n2 = 0
                    
                    self.Marks.removeAll()
                    self.x = anchor.transform.columns.1.y
                    print ("array of Marks: ", self.Marks.count)
                    while n2<marks.count {
                        self.clicked.append(false)
                        self.key.append(k[n2])
                        self.Marks.append(marks[n2])
                        n2 = n2 + 1
                    }
                    self.imageNode = node
                    self.final2 = false
                    print("length of array:  ", self.Marks.count)
                    
                    
                } else {
                    print("no results")
                }
            }) { (error) in
                print(error.localizedDescription)
            }
            print("out of loop:  ", self.Marks.count)
            
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let node = imageNode, let addedNode = addedNode, final , final2 else {
            return
        }
        
        self.flagCounter = self.flagCounter + 1
        let lookAtConstraint = SCNBillboardConstraint()
        node.constraints = [lookAtConstraint]
        node.addChildNode(addedNode)
        self.sceneView.scene.rootNode.addChildNode(node)
        self.sceneView.autoenablesDefaultLighting = true
        self.i = self.i + 1
        self.n = self.n + 1
        final = false
        final2 = false
        
        
        
    }
    
    
    func arraylength(){
        print("in arraylength function:  ", self.Marks.count)
    }
    
    
    
    func getMark(withIndex j: Int) -> SCNNode {
        print ("Marks[",j,"]: ", Marks[j])
        var dis = false
        var text = SCNText(string: Marks[j], extrusionDepth: 0)
        //  print ("self.i-2: ",self.i-1)
        //   var text = SCNText(string: self.Marks[self.i-1], extrusionDepth: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.black
        text.materials = [material]
        text.font = UIFont(name: "FFHekaya-Light", size: 15)
        
        let node2 = SCNNode()
        
        self.x = 1
        print ("X: ", self.x)
        node2.position = SCNVector3(0, self.x/60 , 0)
        
        node2.scale = SCNVector3(0.001, 0.001, 0.001)
        node2.geometry = text
        text = node2.geometry as! SCNText
        
        let minVec = node2.boundingBox.min
        let maxVec = node2.boundingBox.max
        let bound = SCNVector3Make(maxVec.x - minVec.x,
                                   maxVec.y - minVec.y,
                                   maxVec.z - minVec.z);
        node2.pivot = SCNMatrix4MakeTranslation(bound.x / 2,
                                                bound.y / 2,
                                                bound.z / 2)
        
        
        let image = UIImage(named: "flag")
        let planeNode4 = SCNNode(geometry: SCNPlane(width: 15, height: 15))
        planeNode4.geometry?.firstMaterial?.diffuse.contents = image
        planeNode4.position = SCNVector3(-4 , 7, 0)
        
        let plane = SCNPlane(width: CGFloat(bound.x + 37),
                             height: CGFloat(bound.y + 3))
        plane.cornerRadius = 5
        plane.firstMaterial?.diffuse.contents = UIColor.gray.withAlphaComponent(0.75)
        
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(CGFloat( minVec.x  ) + CGFloat(bound.x ) / 2 ,
                                        CGFloat( minVec.y ) + CGFloat(bound.y ) / 2,CGFloat(minVec.z - 0.01))
        
        
        
        //     node2.__getBoundingB
        self.lastPosition = node2.boundingBox.min.x + self.lastPosition + 0.059267633
        //    self.lastPosition = node2.presentation.position.x
        print ("lastPosition: ",self.lastPosition)
        print ("node2.boundingBox.min.x: ",node2.boundingBox.min.x)
        print ("bound.x: ",bound.x)
        self.lastPosition2 = bound.x
        
        node2.addChildNode(planeNode)
        node2.addChildNode(planeNode4)
        planeNode.name = "text"
        
        
        self.flaggedDescription.append(planeNode4.description)
        
        self.flaggedNode.append(planeNode4)
        self.flagCounter = self.flagCounter + 1
        //    let lookAtConstraint = SCNBillboardConstraint()
        
        return node2
        
    }
    
}

