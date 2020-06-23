//
//  ViewController.swift
//  Jawwab
//
//  Created by atheer on 1/22/19.
//  Copyright © 2019 atheer. All rights reserved.
//

import UIKit
import Firebase
import GameplayKit


// For generating random numbers

extension Int {
    static func random(min: Int, max: Int) -> Int {
        precondition(min <= max)
        let randomizer = GKRandomSource.sharedRandom()
        return min + randomizer.nextInt(upperBound: max - min + 1)
    }
}


class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var emptyname: UILabel!
    
    @IBOutlet weak var name: UITextField!
    
    
    @IBOutlet weak var logo: UIImageView!
    
    
    
    @IBOutlet weak var Arabic: UIButton!
    
    @IBOutlet weak var Eng: UIButton!
    
    @IBOutlet weak var female: UIButton!
    
    @IBOutlet weak var male: UIButton!
    
    
    @IBOutlet weak var myimage: UIImageView!
    @IBOutlet  var imagePicker: UIImagePickerController!
    @IBOutlet weak var tapImage: UIButton!
    
    
    
    var flag = true
    
    var gender = 1
    
    var lang = 0
    
    
    
    
    var ref: DatabaseReference!
    
    
    @IBOutlet weak var btn: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        emptyname.isHidden = true
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKey))
        
        view.addGestureRecognizer(tap)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        myimage.isUserInteractionEnabled = true
        myimage.addGestureRecognizer(imageTap)
        myimage.layer.cornerRadius = myimage.bounds.height / 2
        myimage.clipsToBounds = true
        tapImage.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        

    }
    
    @objc func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func DismissKey(){
        view.endEditing(true)
    }
    
    
    @IBAction func ArabicClicked(_ sender: Any) {
      
        
        Arabic.setBackgroundImage(UIImage(named: "langSelected"), for: UIControl.State.normal)
        Eng.setBackgroundImage(UIImage(named: "langntSelected"), for: UIControl.State.normal)
        name.placeholder = "الاسم"
        btn.setTitle("ابدأ", for: .normal)
        logo.image = UIImage(named:"logo.png")
    
        lang = 0
        
    }
    
    
    @IBAction func EnglishClicked(_ sender: Any) {
        
        Arabic.setBackgroundImage(UIImage(named: "langntSelected"), for: UIControl.State.normal)
        Eng.setBackgroundImage(UIImage(named: "langSelected"), for: UIControl.State.normal)
        
        name.placeholder = "Name"
        btn.setTitle("Start", for: .normal)
       logo.image = UIImage(named:"logoeng.png")
        lang = 1
    }
    
    
    @IBAction func femaleClicked(_ sender: Any) {
        
        female.setBackgroundImage(UIImage(named: "GirlSelected"), for: UIControl.State.normal)
        male.setBackgroundImage(UIImage(named: "boy_ntselected"), for: UIControl.State.normal)
        
        myimage.image = #imageLiteral(resourceName: "defaulgirl")
        
        gender = 1
        
    }
    
    
    @IBAction func maleClicked(_ sender: Any) {
        
        male.setBackgroundImage(UIImage(named: "BoySelected"), for: UIControl.State.normal)
        female.setBackgroundImage(UIImage(named: "GirlNtSelected"), for: UIControl.State.normal)
        
        myimage.image = #imageLiteral(resourceName: "defaultboy")
        
        gender = 0
    }
    
    
    // When btn is clicked add these
    @IBAction func btnClicked(_ sender: Any) {
        
        //  let randomInt = Int.random(min: 1, max: 1000)
        //   let randomInt = Int.random(min: 1, max: 1000)
        print("enter click")
         flag = true
        if(name.text?.isEmpty == true){
            emptyname.isHidden = false
            emptyname.text = "لا تترك خانة الاسم فارغة"
            flag = false
        } else if ((name.text?.count)! > 20){
            emptyname.isHidden = false
            emptyname.text = "الاسم لايصح أن يتجاوز ٢٠ حرف"
            flag = false
        }
        
        var str = name.text
        
        let decimalCharacters = CharacterSet.decimalDigits
        
        let decimalRange = str?.rangeOfCharacter(from: decimalCharacters)
        
        if decimalRange != nil {
            flag = false
            emptyname.isHidden = false
            emptyname.text = "الاسم لايصح أن يحتوي على أرقام"
        }
        
        
        if(flag != false){
            // to be tested
            
            // getting the current date of registration
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let resultdate = formatter.string(from: date)
            print(resultdate)
            print("!!!!")
            // getting the current time for registration
            let date1 = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date1)
            let minutes = calendar.component(.minute, from: date1)
            let time = String(hour)  + ":" + String(minutes)
            print(time)
            
            ref = Database.database().reference();
            var userID = Database.database().reference().childByAutoId().key
            userID = userID ?? "id" + "\(lang)"
            ref.child("users").child(userID!).child("Name").setValue(self.name.text)
            //ref.child("users").child(userID).child("School").setValue(self.school.text)
            ref.child("users").child(userID!).child("Gender").setValue(gender)
            ref.child("users").child(userID!).child("UserScore").setValue("0")
            ref.child("users").child(userID!).child("regDate").setValue(resultdate)
            ref.child("users").child(userID!).child("regTime").setValue(time)
            ref.child("users").child(userID!).child("lang").setValue(lang)
           // ref.child("users").child(userID!).child("image").setValue(myimage)
            
    ///pic
            
            // Tracking the Tour
            ref.child("tour").child(userID!).child("user").setValue(userID)
            ref.child("tour").child(userID!).child("q1").setValue(0)
            ref.child("tour").child(userID!).child("q2").setValue(0)
            ref.child("tour").child(userID!).child("q3").setValue(0)
            ref.child("tour").child(userID!).child("q4").setValue(0)
            ref.child("tour").child(userID!).child("q5").setValue(0)
            ref.child("tour").child(userID!).child("q6").setValue(0)
            ref.child("tour").child(userID!).child("q7").setValue(0)
            ref.child("tour").child(userID!).child("q8").setValue(0)
            ref.child("tour").child(userID!).child("q9").setValue(0)
            // Add as much as you need
            ref.child("tour").child(userID!).child("current").setValue(0)
            ref.child("tour").child(userID!).child("level").setValue(0)
            print("user is tracked")
            
            // Save level status
            
            ref.child("levelstatus").child(userID!).child("level1").setValue(0)
            ref.child("levelstatus").child(userID!).child("level2").setValue(0)
            ref.child("levelstatus").child(userID!).child("level3").setValue(0)
            
            print("user added successfully")
            
            
            // session
            UserDefaults.standard.set(userID, forKey:"userId" );
            UserDefaults.standard.set(lang, forKey:"lang" );
            UserDefaults.standard.set(gender, forKey:"gender" );
            UserDefaults.standard.synchronize();
            
            
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if ( flag == false) {
            return false }
        return true
    }
    
  
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.myimage.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}




