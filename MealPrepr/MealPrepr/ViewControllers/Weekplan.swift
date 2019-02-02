//
//  Weekplan.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/2/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import UIKit

private let weekplanCellIdentifier = "weekplanCell"

class Weekplan: MPViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var editWeekplanBtn: UIButton!
    @IBOutlet weak var shoppingCartBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let _ = checkForGuestAccount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: weekplanCellIdentifier, for: indexPath) as! WeekplanRecipeCell
        return cell
    }
    
    @IBAction func addBarBtnClicked(_ sender: Any) {
    }
    
    @IBAction func editBtnClicked(_ sender: Any) {
    }
    
    @IBAction func shoppingCartBtnClicked(_ sender: Any) {
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
