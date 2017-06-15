//
//  EditProfileTableViewController.swift
//  ios_wanted_project
//
//  Created by valerie's mac on 2017/6/11.
//  Copyright © 2017年 Pong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage


class EditProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userTel: UITextField!
    @IBOutlet weak var iconChangeView: UIImageView!
    
    @IBOutlet weak var ImageCell: UITableViewCell!
    @IBOutlet weak var NameCell: UITableViewCell!
    @IBOutlet weak var MailCell: UITableViewCell!
    @IBOutlet weak var TelCell: UITableViewCell!
    @IBOutlet weak var RegionCell: UITableViewCell!
    @IBOutlet weak var BlankCell: UITableViewCell!
    
    var fireUploadDic: [String:Any]?
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let databaseRef = Database.database().reference().child("ProfileUpload")
        
        databaseRef.observe(.value, with: { [weak self] (snapshot) in
            
            if let uploadDataDic = snapshot.value as? [String:Any] {
                
                self?.fireUploadDic = uploadDataDic
                self?.tableView!.reloadData()
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == [0,0] {
            //set the data here
            let cell = ImageCell
            if let dataDic = fireUploadDic {
                //print(dataDic.count)
                let keyArray = Array(dataDic.keys)
                if let imageUrlString = dataDic[keyArray[dataDic.count-1]] as? String {
                    if let imageUrl = URL(string: imageUrlString) {
                        
                        URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
                            
                            if error != nil {
                                
                                print("Download Image Task Fail: \(error!.localizedDescription)")
                            }
                            else if let imageData = data {
                                
                                DispatchQueue.main.async {
                                    
                                    self.iconChangeView.image = UIImage(data: imageData)
                                }
                            }
                            
                        }).resume()
                    }
                }
            }
            return cell!
        }
        else if indexPath == [0,1] {
            let cell = NameCell
            //set the data here
            return cell!
        }
        else if indexPath == [0,2] {
            let cell = MailCell
            return cell!
        }
        else if indexPath == [0,3] {
            let cell = TelCell
            return cell!
        }
        else if indexPath == [0,4] {
            let cell = RegionCell
            return cell!
            
        }
        else{
            let cell = BlankCell
            return cell!
        }
    }


    @IBAction func editProfileDone(_ sender: UIBarButtonItem) {
        
        // Set Reference
        var ref : DatabaseReference!
        ref = Database.database().reference(withPath: "User")
        // Get user info
        let name = userName.text
        let tel = userTel.text
        let email: String = (Auth.auth().currentUser?.email)!
        let uid: String = (Auth.auth().currentUser?.uid)!
        let image = self.imageUrl
        // Create new Object (User)
        let userRef = ref.child("\(uid)")
        
        // Child update 
        if name != "" {
            let updateName = name!
            userRef.updateChildValues(["name": updateName])
        }
        if email != "" {
            let updateTel = tel!
            userRef.updateChildValues(["tek": updateTel])
        }
        if image != nil {
            let updateImage = image!
            userRef.updateChildValues(["image": updateImage])
        }
        userRef.updateChildValues(["email": email])
        userRef.updateChildValues(["uid": uid])

    }
    
    @IBAction func ChangeImage(_ sender: UIButton) {
        
        // 建立一個 UIImagePickerController 的實體
        let imagePickerController = UIImagePickerController()
        
        // 委任代理
        imagePickerController.delegate = self
        
        // 建立一個 UIAlertController 的實體
        // 設定 UIAlertController 的標題與樣式為 動作清單 (actionSheet)
        let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
        
        // 建立三個 UIAlertAction 的實體
        // 新增 UIAlertAction 在 UIAlertController actionSheet 的 動作 (action) 與標題
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (Void) in
            
            // 判斷是否可以從照片圖庫取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.photoLibrary)，並 present UIImagePickerController
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (Void) in
            
            // 判斷是否可以從相機取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.camera)，並 present UIImagePickerController
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        // 新增一個取消動作，讓使用者可以跳出 UIAlertController
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in
            
            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }
        
        // 將上面三個 UIAlertAction 動作加入 UIAlertController
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)
        
        // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
        present(imagePickerAlertController, animated: true, completion: nil)
    }
    
    
}

extension EditProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        // 取得從 UIImagePickerController 選擇的檔案
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            selectedImageFromPicker = pickedImage
        }
        
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        let uniqueString = NSUUID().uuidString
        self.imageUrl = ("\(uniqueString).png")
       
        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
        if let selectedImage = selectedImageFromPicker {
            
            let storageRef = Storage.storage().reference().child("ProfileUpload").child("\(uniqueString).png")
            if let uploadData = UIImagePNGRepresentation(selectedImage) {
                // 這行就是 FirebaseStroge 關鍵的存取方法。
                storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
                    
                    if error != nil {
                        
                        // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
                        print("Error: \(error!.localizedDescription)")
                        return
                    }
                    
                    // 連結取得方式就是：data?.downloadURL()?.absoluteString。
                    if let uploadImageUrl = data?.downloadURL()?.absoluteString {
                        
                        // 我們可以 print 出來看看這個連結事不是我們剛剛所上傳的照片。
                        print("Photo Url: \(uploadImageUrl)")
                        
                        let databaseRef = Database.database().reference().child("ProfileUpload").child(uniqueString)
                        
                        databaseRef.setValue(uploadImageUrl, withCompletionBlock: { (error, dataRef) in
                            
                            if error != nil {
                                print("Database Error: \(error!.localizedDescription)")
                            }
                            else {
                                print("圖片已儲存")
                            }
                        })
                    }
                })
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
//    static func getImageUrl (get imageUrl: String ) -> String {
//        
//        return imageUrl
//    }
   
    }
