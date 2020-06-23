//
//  testViewController.swift
//  Jawwab
//
//  Created by Nora AlMunaif on 09/04/2019.
//  Copyright © 2019 atheer. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let Question1ViewController = storyBoard.instantiateViewController(withIdentifier: "mainView") as! Question1ViewController
        
        self.present(Question1ViewController, animated: false, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
