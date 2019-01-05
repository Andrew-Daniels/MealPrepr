//
//  Loading.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 1/5/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

class Loading: UIViewController {
    
    @IBOutlet weak var loadingLabel: UILabel!
    var loadingText = "Loading"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingLabel.text = loadingText
        // Do any additional setup after loading the view.
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