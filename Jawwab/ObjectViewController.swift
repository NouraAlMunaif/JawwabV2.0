//
//  ObjectViewController.swift
//  Jawwab
//
//  Created by Reema on 29/01/2019.
//  Copyright © 2019 atheer. All rights reserved.
//

import UIKit
import ARKit
import EstimoteProximitySDK

class ObjectViewController: UIViewController {
    var proximityObserverCoconut: ProximityObserver!
    var proximityObserverMint: ProximityObserver!
    var nearbyContent = [Content]()
    
    
    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var flagCoconut = false;
        var flagMint = false;
        
        /// ////////////////////Coconut//////////////////////////
        let coconut = CloudCredentials(appID: "jawab-test-2m5", appToken: "6ff2355c245c7d7953c64eb5c2a912ba")
        
        proximityObserverCoconut = ProximityObserver(credentials: coconut, onError: { error in
            print("ProximityObserver error: \(error)")
        })
        
        let coconutZone = ProximityZone(tag: "jawab-test-2m5", range: ProximityRange.near)
        if(flagMint==false){
            coconutZone.onEnter = { contexts in
                flagCoconut=true;
                print("enter coconut zone")
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let QuestionViewController = storyBoard.instantiateViewController(withIdentifier: "Questionscene") as! QuestionViewController
                self.present(QuestionViewController, animated: true, completion: nil)
                
            }
            
            coconutZone.onExit = { contexts in
                print("Exit")
                flagCoconut=false;
                
            }
            proximityObserverCoconut.startObserving([coconutZone])
        }
        // ///////////////////////////////Coconut////////////////////////////
        
        
        
        
        
        // ////////////////////mint//////////////////////////
      /*  let mint = CloudCredentials(appID: "reem-badr-s-proximity-for--6o4", appToken: "8be2dff5dc16b9747b7fafe97ff53708")
        
        
        proximityObserverMint = ProximityObserver(credentials: mint , onError: { error in
            print("ProximityObserver error: \(error)")
            
        })
        
        let mintZone = ProximityZone(tag: "reem-badr-s-proximity-for--6o4", range: ProximityRange.near)
        if(flagCoconut==false){
            mintZone.onEnter = { contexts in
                flagMint=true;
                print("enter mint zone")
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let QuestViewController = storyBoard.instantiateViewController(withIdentifier: "questScene") as! QuestViewController
                self.present(QuestViewController, animated: true, completion: nil)
            }
            
            mintZone.onExit = { contexts in
                flagMint=true;
                print("Exit")
            }
            proximityObserverMint.startObserving([mintZone])
        }}
    // ////////////////////mint///////////////////////////////////////////
    */
    
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
  

    
    
    
}
