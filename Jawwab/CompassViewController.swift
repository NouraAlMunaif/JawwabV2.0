//
//  CompassViewController.swift
//  compass
//
//  Created by Federico Zanetello on 05/04/2017.
//  Copyright © 2017 Kimchi Media. All rights reserved.
//

import UIKit
import CoreLocation
import ARKit

class CompassViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  
    @IBOutlet weak var popup: UIImageView!
    var node: SCNNode!
    @IBOutlet weak var popupText: UILabel!
    @IBOutlet weak var popupButton: UIButton!
    @IBOutlet weak var mapt: UIImageView!
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var view1: UIView!
    @IBAction func showChallenge(_ sender: Any) {
        view1.isHidden = true
        imageView.isHidden = false
        displayAR()
    }
    
    let userId = UserDefaults.standard.object(forKey: "userId") as? String
    let lang = UserDefaults.standard.object(forKey: "lang") as? Int
    
    let locationDelegate = LocationDelegate()
  var latestLocation: CLLocation? = nil
  var yourLocationBearing: CGFloat { return latestLocation?.bearingToLocationRadian(self.yourLocation) ?? 0 }
  var yourLocation: CLLocation {
    get { return UserDefaults.standard.currentLocation }
    set { UserDefaults.standard.currentLocation = newValue }
  }
  
    
  let locationManager: CLLocationManager = {
    $0.requestWhenInUseAuthorization()
    $0.desiredAccuracy = kCLLocationAccuracyBest
    $0.startUpdatingLocation()
    $0.startUpdatingHeading()
    return $0
  }(CLLocationManager())
  
  private func orientationAdjustment() -> CGFloat {
    let isFaceDown: Bool = {
      switch UIDevice.current.orientation {
      case .faceDown: return true
      default: return false
      }
    }()
    
    let adjAngle: CGFloat = {
      switch UIApplication.shared.statusBarOrientation {
      case .landscapeLeft:  return 90
      case .landscapeRight: return -90
      case .portrait, .unknown: return 0
      case .portraitUpsideDown: return isFaceDown ? 180 : -180
      }
    }()
    return adjAngle
  }
  
    func displayAR(){
        var content = "!!"
        if(lang==1){
            content = "You did it "}
            
        else{
            content = "فعلتها!! وجدت الكنز" }
        
        
        
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
        
        let image = UIImage(named: "mapt")
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.isHidden = true
    locationManager.delegate = locationDelegate
    if (lang==1){
        
        popupText.text = "Excellent you reached the final challenge!, now please go five steps  towards the arrow"
        
        popupButton.setTitle("Next", for: .normal)
        
    }
    locationDelegate.locationCallback = { location in
      self.latestLocation = location
    }
    
    locationDelegate.headingCallback = { newHeading in
      
      func computeNewAngle(with newAngle: CGFloat) -> CGFloat {
        let heading: CGFloat = {
          let originalHeading = self.yourLocationBearing - newAngle.degreesToRadians
          switch UIDevice.current.orientation {
          case .faceDown: return -originalHeading
          default: return originalHeading
          }
        }()
        
        return CGFloat(self.orientationAdjustment().degreesToRadians + heading)
      }
      
      UIView.animate(withDuration: 0.5) {
        let angle = computeNewAngle(with: CGFloat(newHeading))
        self.imageView.transform = CGAffineTransform(rotationAngle: angle)
      }
    }
}
    
}
