//
//  PreviewViewController.swift
//  Jawwab
//
//  Created by iMac on 17/08/1440 AH.
//  Copyright © 1440 atheer. All rights reserved.
//


import UIKit

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    
    var image: UIImage!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image
        
        
        var filter = UIImage(named: "filter.png")
        
        var size = CGSize(width: 300, height: 300)
        UIGraphicsBeginImageContext(size)
        
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.image!.draw(in: areaSize)
        
        filter!.draw(in: areaSize, blendMode: .normal, alpha: 0.8)
        
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        photo.image = newImage
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cancelButton_TouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButton_TouchUpInside(_ sender: Any) {
        /* guard let imageToSave = image else {
         return
         }
         
         UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil) */
        dismiss(animated: true, completion: nil)
    }
    
    /*override func didReceiveMemoryWarning() {
     super.didReceiveMemoryWarning()
     // Dispose of any resources that can be recreated.
     } */
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

