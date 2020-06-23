//
//  PuzzleViewController.swift
//  Jawwab
//
//  Created by Reema on 01/02/2019.
//  Copyright © 2019 atheer. All rights reserved.
//
// this code have been done using this tutorial :https://www.youtube.com/watch?v=7iuGVKAcCOo&t=916s

import UIKit
import AVFoundation
import Firebase
class PuzzleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var postPopupText: UILabel!
    @IBOutlet weak var upLabel: UILabel!
    @IBOutlet weak var prePopupText: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    // session
    let userId = UserDefaults.standard.object(forKey: "userId") as? String
    let lang = UserDefaults.standard.object(forKey: "lang") as? Int
    var ref: DatabaseReference!
    let questionImageArray = [ #imageLiteral(resourceName: "4"),  #imageLiteral(resourceName: "2"),  #imageLiteral(resourceName: "3"),  #imageLiteral(resourceName: "1"),  #imageLiteral(resourceName: "5"),  #imageLiteral(resourceName: "8"),  #imageLiteral(resourceName: "7"),  #imageLiteral(resourceName: "9"),  #imageLiteral(resourceName: "6")]
   let correctAns = [7,5,6,8,4,0,2,1,3]
    var wrongAns = Array(0..<9)
    var wrongImageArray=[UIImage]()
    var undoMovesArray = [(first: IndexPath, second: IndexPath)]()
    var numberOfMoves = 0
    // let lang = UserDefaults.standard.object(forKey: "lang") as? Int
    
    var firstIndexPath: IndexPath?
    var secondIndexPath: IndexPath?

    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing=0
        layout.minimumLineSpacing=0
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.allowsMultipleSelection = true
        cv.translatesAutoresizingMaskIntoConstraints=false
        return cv
    }()
    

    
    let btnSwap: UIButton = {
        
        let btn=UIButton(type: .system)
        //if (lang == 1){
        btn.setTitle("Switch" , for: .normal)
       // }
    //    else{
            btn.setTitle("تبديل", for: .normal)
            
       // }
        btn.titleLabel?.font =  UIFont(name: "FF Hekaya" , size: 20)
        btn.setBackgroundImage(UIImage(named: "actionbtn"), for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
        
    }()
    
    let btnUndo: UIButton = {
        let btn=UIButton(type: .system)
       // if (lang == 1){
            btn.setTitle("Undo" , for: .normal)
       // }
      //  else{
            btn.setTitle("تراجع", for: .normal)
        
  //  }
        btn.titleLabel?.font =  UIFont(name: "FF Hekaya" , size: 20)
        btn.setBackgroundImage(UIImage(named: "actionbtn"), for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        
        return btn
    }()
    
    
     var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playSound(fileName: "popUp")
        wrongImageArray = questionImageArray
      //  setupViews()
       self.EndUserSession()
        view2.isHidden = true
        
        if(lang==1){
            btnUndo.setTitle("Undo" , for: .normal)
            btnSwap.setTitle("Switch" , for: .normal)
            nextButton.setBackgroundImage(UIImage(named: "engnext"), for: UIControl.State.normal)
            skipBtn.setBackgroundImage(UIImage(named: "Skipchalangeeng"), for: UIControl.State.normal)
            prePopupText.text = "Figure out the required image"
            postPopupText.text = "Prophet Mohammed conquested Mecca with an army of ten thousands Muslims"
            upLabel.text = "Information"
                 }
        
        

    }
 
    @IBAction func nextBtn(_ sender: Any) {
        view1.isHidden = true
        setupViews()
    }
    

    func playSound(fileName: String) {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
   
    
    
    
    @objc func btnSwapAction() {
        guard let start = firstIndexPath, let end = secondIndexPath else { return }
        myCollectionView.performBatchUpdates({
            myCollectionView.moveItem(at: start, to: end)
            myCollectionView.moveItem(at: end, to: start)
        }) { (finished) in
            
            self.myCollectionView.deselectItem(at: start, animated: true)
            self.myCollectionView.deselectItem(at: end, animated: true)
            self.firstIndexPath = nil
            self.secondIndexPath = nil
            self.wrongImageArray.swapAt(start.item, end.item)
            self.wrongAns.swapAt(start.item, end.item)
            self.undoMovesArray.append((first: start, second: end))
            self.numberOfMoves += 1
            
            if self.wrongAns == self.correctAns {
                
                self.solveChallange(q: 4, status: 1)
                self.setCurrent(q: 4)
                // solve aziz issue
                self.myCollectionView.isHidden = true
                self.btnUndo.isHidden = true
                self.btnSwap.removeFromSuperview()
                
                self.view2.isHidden = false
               
              
      
                
            }
        }
    }
    
    @IBAction func skipBtn(_ sender: Any) {
        self.solveChallange(q: 4, status: 2)
        self.setCurrent(q: 4)
       self.skipBtn.removeFromSuperview()
        self.myCollectionView.removeFromSuperview()
        self.btnUndo.removeFromSuperview()
        self.btnSwap.removeFromSuperview()
         self.view1.removeFromSuperview()
        self.view2.removeFromSuperview()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let skipViewController = storyBoard.instantiateViewController(withIdentifier: "skip") as! skipViewController
        
        self.present(skipViewController, animated: false, completion: nil)
    }
    @IBAction func close(_ sender: Any) {
        self.skipBtn.removeFromSuperview()
        self.myCollectionView.removeFromSuperview()
        self.btnUndo.removeFromSuperview()
        self.btnSwap.removeFromSuperview()
        self.view1.removeFromSuperview()
        self.view2.removeFromSuperview()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let SuccessMessagesViewController = storyBoard.instantiateViewController(withIdentifier: "QMessage") as! SuccessMessagesViewController
        
        self.present(SuccessMessagesViewController, animated: true, completion: nil)

    }
    
    
    
    func restartGame() {
        self.undoMovesArray.removeAll()
        wrongAns = Array(0..<9)
        wrongImageArray = questionImageArray
        firstIndexPath = nil
        secondIndexPath = nil
        self.numberOfMoves = 0
        
        self.myCollectionView.reloadData()
    }
    
    func setupViews() {
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(ImageViewCVCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.backgroundColor=UIColor.white
        
        
        
        self.view.addSubview(myCollectionView)
        myCollectionView.leftAnchor.constraint(equalTo:  self.view.leftAnchor, constant: 20).isActive=true
        myCollectionView.topAnchor.constraint(equalTo:  self.view.topAnchor, constant: 150).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo:  self.view.rightAnchor, constant: -21).isActive=true
        myCollectionView.heightAnchor.constraint(equalTo: myCollectionView.widthAnchor).isActive=true
        
        
        
        
        self.view.addSubview(btnSwap)
        
        btnSwap.widthAnchor.constraint(equalToConstant: 150).isActive=true
        btnSwap.topAnchor.constraint(equalTo: myCollectionView.bottomAnchor, constant: 1).isActive=true
        btnSwap.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 210).isActive=true
        btnSwap.heightAnchor.constraint(equalToConstant: 70).isActive=true
        btnSwap.addTarget(self, action: #selector(btnSwapAction), for: .touchUpInside)
        
        self.view.addSubview(btnUndo)
        btnUndo.widthAnchor.constraint(equalToConstant: 150).isActive=true
        btnUndo.topAnchor.constraint(equalTo: myCollectionView.bottomAnchor, constant: 1).isActive=true
        btnUndo.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive=true
        btnUndo.heightAnchor.constraint(equalToConstant: 70).isActive=true
        btnUndo.addTarget(self, action: #selector(btnSwapAction), for: .touchUpInside)
        
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
    
    //MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageViewCVCell
        cell.imgView.image=wrongImageArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if firstIndexPath == nil {
            firstIndexPath = indexPath
            collectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        } else if secondIndexPath == nil {
            secondIndexPath = indexPath
            collectionView.selectItem(at: secondIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        } else {
            collectionView.deselectItem(at: secondIndexPath!, animated: true)
            secondIndexPath = indexPath
            collectionView.selectItem(at: secondIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath == firstIndexPath {
            firstIndexPath = nil
        } else if indexPath == secondIndexPath {
            secondIndexPath = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width/3, height: width/3)
    }
    
    
    func initChallange(q: Int){
        ref = Database.database().reference();
        var userId = UserDefaults.standard.object(forKey: "userId") as? String
        // 0 ==> not solved  || 1 ==> solved
        self.ref.child("tour").child(userId!).child("q\(q)").setValue(0)
        
    }
    
    func solveChallange(q: Int, status: Int){
        ref = Database.database().reference();
        var userId = UserDefaults.standard.object(forKey: "userId") as? String
        // 0 ==> not solved  // 1 ==> solved
        self.ref.child("tour").child(userId!).updateChildValues(["q\(q)": status])
        
    }
    
    func setCurrent(q: Int){
        ref = Database.database().reference();
        var userId = UserDefaults.standard.object(forKey: "userId") as? String
        self.ref.child("tour").child(userId!).updateChildValues(["current": q])
        
        
    }
}
