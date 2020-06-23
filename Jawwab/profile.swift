//
//  profile.swift
//  Jawwab
//
//  Created by Nouf on 2/23/19.
//  Copyright © 2019 atheer. All rights reserved.
//

import Foundation
class profile{
    
    var username: String?
    var score: String?
    var key :String?
    
    
    init(username: String?, score: String?, key: String?){
        if(username != "u"){
            self.username=username}
        
        if(score != "s"){
            self.score=score}
        
        if (key != ""){
            self.key=key
        }
    }
}
