//
//  MainPageViewController.swift
//  ios_wanted_project
//
//  Created by Pong on 2017/5/23.
//  Copyright © 2017年 Pong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainPageViewController: UIViewController {
    static var btnName : String = ""
    
    @IBOutlet weak var a: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let blureffectView = UIVisualEffectView(effect: blurEffect)
//        blureffectView.frame = a.bounds
//        a.addSubview(blureffectView)
        
        self.tabBarController?.navigationItem.hidesBackButton = true
//        
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Wanted20Poster-filtered.png")!)
//    
        
        //get uid test

        let userID : String = (Auth.auth().currentUser?.uid)!
        let userEmail: String = (Auth.auth().currentUser?.email)!
        print("Current user ID is： " + userID)
        print("Current user email is： " + userEmail)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CategoryBtn(_ sender: UIButton) {
        let categoryArray = ["Cleaning", "Fixing", "Childcare", "Pets", "Cooking", "Tutoring"]
        
        for var i in 1...6 {
            i += 1000;
            if(sender.tag == i){
                PostListViewController.category = categoryArray[i-1001]
                MainPageViewController.btnName = sender.currentTitle!
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
