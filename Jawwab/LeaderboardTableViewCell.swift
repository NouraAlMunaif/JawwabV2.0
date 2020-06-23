//
//  LeaderboardTableViewCell.swift
//  Jawwab
//
//  Created by Reema on 12/03/2019.
//  Copyright © 2019 atheer. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {

 
    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var playerScore: UILabel!
    
  
    @IBOutlet weak var rank: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /*self.contentView.layer.cornerRadius = 70
        self.contentView.clipsToBounds = true*/
     
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func CellInit(Pname: String, Pscore: String, rank: String){
        
        self.playerName.text=Pname
        self.playerScore.text=Pscore
        self.rank.text=rank
   
        
    }
    
}
