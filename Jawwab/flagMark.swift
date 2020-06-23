//
//  flagMark.swift
//  Jawwab
//
//  Created by Nora Almunaif on 11/02/2019.
//  Copyright © 2019 atheer. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class flagMark {
    var flaggedNode: SCNNode!
    
    var ID: String!
    var delegate: AppDelegate //non-optional variable
    
    init() {
        delegate = UIApplication.shared.delegate as! AppDelegate
        flaggedNode = SCNNode()
        ID = ""
    }
    
}
