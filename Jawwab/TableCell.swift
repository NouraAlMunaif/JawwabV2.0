//
//  TableCell.swift
//  Jawwab
//
//  Created by Nouf on 2/23/19.
//  Copyright © 2019 atheer. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {

    
    
    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var playerScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func CellInit(Pname: String, Pscore: String){
      
        self.playerName.text=Pname
       // let  Pscore1 = String(Pscore)
        self.playerScore.text=Pscore
        
        // assigning colors
        self.playerName.textColor = UIColor.gray
        self.playerScore.textColor = UIColor.gray
        
    }
}
