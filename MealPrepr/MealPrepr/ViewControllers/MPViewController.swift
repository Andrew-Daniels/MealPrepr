//
//  MPViewController.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/8/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

class MPViewController: UIViewController {
    
    var account: Account!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MPViewController {
            vc.account = account
        } else if let vc = segue.destination as? MPNavigationController {
            vc.account = account
        } else if let vc = segue.destination as? MPTabBarController {
            vc.account = account
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth : CGFloat = 170.0
        
        let numberOfCells = floor(self.view.frame.size.width / cellWidth)
        let edgeInsets = (self.view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
        return UIEdgeInsets.init(top: 15, left: edgeInsets, bottom: 0, right: edgeInsets)
    }
    
    func checkIfTouchesAreInside(touches: Set<UITouch>, ofView: UIView) -> Bool {
        if let touch = touches.first {
            let touchLocation = touch.location(in: ofView)
            print(touchLocation)
            let viewFrame = ofView.convert(ofView.frame, from: ofView.superview)
            
            return viewFrame.contains(touchLocation)
        }
        return false
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
