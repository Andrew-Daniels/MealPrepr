//
//  Settings.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 1/29/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

class Settings: MPViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var changePhotoBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateJoinedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.account.getProfilePicture { (image) in
            self.profileImageView.image = image
        }
    }
    
    @IBAction func changePhotoBtnClicked(_ sender: Any) {
        showImagePickerController()
    }
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        super.imagePickerController(picker, didFinishPickingMediaWithInfo: info)
        if let image = self.selectedImage {
            self.account.setProfilePicture(image: image)
            self.profileImageView.image = image
        }
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
