//
//  Settings.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 1/29/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

private let tableViewCellIdentifier = "settingCell"
private let changeAccountInfoAlertSegueIdentifier = "changeAccountInfo"

class Settings: MPViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var changePhotoBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateJoinedLabel: UILabel!
    var settingsTableViewModel = [SettingsOption]()
    
    enum SettingsOption: String {
        case ChangeUsername = "Change Username"
        case ChangeEmail = "Change Email Address"
        case ChangePassword = "Change Password"
        case MyRecipes = "My Recipes"
        case Admin = "Admin"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.account.getProfilePicture { (image) in
            self.profileImageView.image = image
        }
        
        setupSettings()
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2
        self.changePhotoBtn.layer.cornerRadius = self.profileImageView.bounds.size.width / 2
        
        if let date = self.account.dateJoined?.detail {
            self.dateJoinedLabel.text = "Date Joined: \(date)"
        }
        self.usernameLabel.text = self.account.username
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsTableViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier)!
        let cellType = settingsTableViewModel[indexPath.row]
        
        cell.textLabel?.text = cellType.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = settingsTableViewModel[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        switch cellType {
            
        case .ChangeUsername:
            performSegue(withIdentifier: changeAccountInfoAlertSegueIdentifier, sender: cellType)
        case .ChangeEmail:
            performSegue(withIdentifier: changeAccountInfoAlertSegueIdentifier, sender: cellType)
        case .ChangePassword:
            performSegue(withIdentifier: changeAccountInfoAlertSegueIdentifier, sender: cellType)
        case .MyRecipes:
            break
        case .Admin:
            break
        }
        
    }
    
    func setupSettings() {
        settingsTableViewModel = [.ChangeUsername, .ChangeEmail, .ChangePassword, .MyRecipes]
        if self.account.isFBAuth {
            settingsTableViewModel = [.ChangeUsername, .MyRecipes]
        }
        if self.account.userLevel == .Admin {
            settingsTableViewModel.append(.Admin)
        }
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == changeAccountInfoAlertSegueIdentifier,
            let setting = sender as? SettingsOption,
            let vc = segue.destination as? ChangeAccountInfoAlert {
            
            switch setting {
                
            case .ChangeUsername:
                vc.changeType = .Username
                vc.requiresCurrentPassword = !self.account.isFBAuth
                break
            case .ChangeEmail:
                vc.changeType = .Email
                break
            case .ChangePassword:
                vc.changeType = .Password
                break
            case .MyRecipes:
                break
            case .Admin:
                break
            }
            
        }
    }

}
