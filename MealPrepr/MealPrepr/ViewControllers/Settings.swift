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
    @IBOutlet weak var choosePhotoBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateJoinedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func choosePhotoBtnClicked(_ sender: Any) {
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
