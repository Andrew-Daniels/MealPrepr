//
//  Favorites.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 1/14/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

private let categoryAlertSegueIdentifier = "CategoryAlert"

class Categories: MPViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkForGuestAccount()
    }
    
    @IBAction func backToCategories(segue: UIStoryboardSegue) {
    }
    
    @IBAction func favoritesBtnClicked(_ sender: Any) {
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
