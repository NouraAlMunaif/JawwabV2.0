//
//  AnimationInfo.swift
//  Jawwab
//
//  Created by Nora Almunaif on 03/06/1440 AH.
//  Copyright © 1440 atheer. All rights reserved.
//

import Foundation
import SceneKit

struct AnimationInfo {
    var startTime: TimeInterval
    var duration: TimeInterval
    var initialModelPosition: simd_float3
    var finalModelPosition: simd_float3
    var initialModelOrientation: simd_quatf
    var finalModelOrientation: simd_quatf
}
