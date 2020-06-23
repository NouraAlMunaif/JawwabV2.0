//
//  Question.swift
//  Proximity
//
//  Created by Reema on 27/01/2019.
//  Copyright © 2019 Estimote, Inc. All rights reserved.
//

import Foundation
class Question{
    private var content : String?
    /*{
        get{
            return self.content;
        }
        
       set(content)
        {
        self.content=content
        }
    }*/
    private  var answers = [String]()
    private  var score : Int?//{
    // get{
        //    return self.score;
       // }
        //  set(score)
      //  {
         //   self.score=score
       // }
   // }
    
    
    init(content : String?, answers: [String], score : Int?) {
        self.content = content
        self.answers = answers
        self.score = score 
    }
    
}
