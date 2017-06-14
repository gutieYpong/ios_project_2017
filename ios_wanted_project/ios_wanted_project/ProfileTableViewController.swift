//
//  ProfileTableViewController.swift
//  ios_wanted_project
//
//  Created by valerie's mac on 2017/6/8.
//  Copyright © 2017年 Pong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var FirstCell: UITableViewCell!
    
    var fireUploadDic: [String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(44,0,0,0);
        
        let databaseRef = Database.database().reference().child("ProfileUpload")
        
        databaseRef.observe(.value, with: { [weak self] (snapshot) in
            
            if let uploadDataDic = snapshot.value as? [String:Any] {
                
                self?.fireUploadDic = uploadDataDic
                self?.tableView!.reloadData()
            }
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutBtn(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    // #warning Incomplete implementation, return the number of rows
    {
        if (section == 0){
            return 2
        } else if (section == 1){
            return 2}
        else if (section == 2){
            return 2
        }
        else
        {
        return 1
        }
    }
    
    @IBAction func undiwndToHomeScreen(segue:UIStoryboardSegue){
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if indexPath.section == 0 && indexPath.row == 0 {
            //let cell : FirstCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "firstCell")
            //set the data here
            let cell = FirstCell
            if let dataDic = fireUploadDic {
                let keyArray = Array(dataDic.keys)
                print(keyArray[dataDic.count-1])
                if let imageUrlString = dataDic[keyArray[dataDic.count-1]] as? String {
                    print(imageUrlString)
                    if let imageUrl = URL(string: imageUrlString) {
                        
                        URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
                            
                            if error != nil {
                                
                                print("Download Image Task Fail: \(error!.localizedDescription)")
                            }
                            else if let imageData = data {
                                
                                DispatchQueue.main.async {
                                    
                                    self.iconView.image = UIImage(data: imageData)
                                }
                            }
                            
                        }).resume()
                    }
                }
            }
          //  iconView.image = UIImage(named: "gear")
           // print("im here")
            return cell!
        }
        else{
            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "FirstCell")
            //set the data here
            return cell
        }
    
        // Configure the cell...

        //return cell
    }
    

    
}
