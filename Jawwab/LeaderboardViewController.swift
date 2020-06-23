//
//  LeaderboardViewController.swift
//  Jawwab
//
//  Created by Reema on 12/03/2019.
//  Copyright © 2019 atheer. All rights reserved.
//

import UIKit
import Firebase
//import SAConfettiView

class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    

    @IBOutlet weak var leaderbored: UILabel!
    var fetchingMore = false
    
    //session
    let userId = UserDefaults.standard.object(forKey: "userId") as? String
    var ref: DatabaseReference!
    var LeaderboardList = [profile]()
    var newLeaderboardList = [profile]()
    let cellSpacingHeight: CGFloat = 5
    var timerForShowScrollIndicator: Timer?
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstScore: UILabel!
    
    @IBOutlet weak var secondLabel: UILabel!
   @IBOutlet weak var secondScore: UILabel!
    
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var thirdScore: UILabel!
    @IBOutlet weak var ballons: UIImageView!
    var temp = 0
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userId = UserDefaults.standard.object(forKey: "userId") as? String
        ref = Database.database().reference()
        let  userLang = ref.child("users").child(userId!).child("lang")
        userLang.observeSingleEvent(of: .value, with: { (snapshot) in
            let lang = snapshot.value as? Int
            if(lang==1){
             
               self.leaderbored.text = "Leaderbored"
               self.ballons.image = UIImage(named:"bal2eng.jpg")
            }
            
            
        })
        self.EndUserSession()
        self.tableView.flashScrollIndicators()
 /*      let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.type = .Diamond
        confettiView.isUserInteractionEnabled = false
        self.view.addSubview(confettiView)
        
        confettiView.startConfetti()*/
      
        
        let nib = UINib(nibName: "LeaderboardTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LeaderboardTableViewCell")
        
        //For Auto Resize Table View Cell;
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        //Detault Background clear
        tableView.backgroundColor = UIColor.clear
        
        ///////////// users sorting ///////////
        ref = Database.database().reference();
        let leaderboadInfo = ref.child("users")
        leaderboadInfo.observe(DataEventType.value, with: { (snapshot) in
            
            self.LeaderboardList.removeAll()
            
            for info in snapshot.children.allObjects as! [DataSnapshot]{
                
                let infoObject = info.value as? [String: AnyObject]
                let key = info.key as String
                var name = infoObject?["Name"]
                let  score = infoObject?["UserScore"]
                print(name!)
                
                
let LeaderboardObject = profile(username: name as! String?, score: score as! String?,key: key as String?)
                self.LeaderboardList.append(LeaderboardObject)
                
                
            }
            
            self.tableView.reloadData()
            
            self.LeaderboardList = self.LeaderboardList.sorted{ Int($0.score ?? "7") ?? 7 > Int($1.score ?? "7") ?? 7 }
            
            /////////////// assigning the balloons with the top 3///////////////////
            if(self.LeaderboardList.count >= 1){
            let fisrtplaceName =  self.LeaderboardList[0].username
            self.firstLabel.text = fisrtplaceName
            let firstplaceScore = self.LeaderboardList[0].score
                self.firstScore.text = firstplaceScore}
               if(self.LeaderboardList.count >= 2){
            let secondplaceName =  self.LeaderboardList[1].username
            self.secondLabel.text=secondplaceName
            let secondplaceScore = self.LeaderboardList[1].score
                self.secondScore.text = secondplaceScore}
            if(self.LeaderboardList.count >= 3){
            
            let thirdplaceName =  self.LeaderboardList[2].username
            self.thirdLabel.text=thirdplaceName
            let thirdplaceScore = self.LeaderboardList[2].score
                self.thirdScore.text = thirdplaceScore}
            
            /////////////// assigning the balloons with the top 3///////////////////
            if (self.LeaderboardList.count >= 1){
                self.LeaderboardList.remove(at: 0 )}
            
            if (self.LeaderboardList.count >= 1){
                self.LeaderboardList.remove(at: 0 )}
            
            
            if (self.LeaderboardList.count >= 1){
                self.LeaderboardList.remove(at: 0 )}
            
       
            var r=0
            while(r<self.LeaderboardList.count){
                if (self.LeaderboardList[r].key == userId){
                    print("****************@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                    print(self.LeaderboardList[r].username)
                    print("****************@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                    self.temp = r
                    let UserOrder = self.LeaderboardList[r]
                    self.LeaderboardList.remove(at: r)
                    self.LeaderboardList.insert(UserOrder, at: 0)
                }
                r = r+1
            }

           
            
      //b  }
            
        })
       /* var i=3
        var j=0;
        while (i<self.LeaderboardList.count){
            
            self.newLeaderboardList.append(self.LeaderboardList[i])
            
            print( self.newLeaderboardList[j].username)
            i = i+1
            j = j+1}*/
        
        
        
        }
//self.newLeaderboardList = Array(self.LeaderboardList[3..<self.LeaderboardList.count])
   
     /*  self.LeaderboardList.remove(at: 1 )
         self.LeaderboardList.remove(at: 2 )
         self.LeaderboardList = self.LeaderboardList.filter() { $0 !== self.LeaderboardList[0] }
         self.LeaderboardList = self.LeaderboardList.filter() { $0 !== self.LeaderboardList[1] }
          self.LeaderboardList = self.LeaderboardList.filter() { $0 !== self.LeaderboardList[2] }*/
  
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
       // print("leaderbord count ")
      print(LeaderboardList.count)
      // print(newLeaderboardList.count)
        return LeaderboardList.count-3
      
    }
  

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, heightForSectionAt indexPath: IndexPath) -> CGFloat
    {
        return 70
    }
    
    
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 14
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardTableViewCell") as! LeaderboardTableViewCell
        cell.isUserInteractionEnabled = false;
        var rank = "0";
        
        if(indexPath.section==0){
            
            rank = String(self.temp + 3)
            
            cell.backgroundColor = hexStringToUIColor(hex:"FECA9E")
            
        }
            
        else{
            rank = String(indexPath.section + 3)
            cell.backgroundColor = UIColor.white
        }
        
        cell.CellInit(Pname: LeaderboardList[indexPath.section].username ?? "u", Pscore : LeaderboardList[indexPath.section].score ?? "s", rank: rank)
        
        return cell
     
    }

    
    @IBAction func dismis(_ sender: Any) {
        dismiss(animated: true)
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
   func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollHeight = scrollView.frame.size.height
        if offsetY >= contentHeight - scrollHeight
        {
            if !fetchingMore{
                beginBatchFetch()
            }
        }
    }
    
    
    func beginBatchFetch(){
        
        fetchingMore = true
        print("begin batch fetch")
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
 
}
