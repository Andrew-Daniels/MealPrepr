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
    var searchController: UISearchController?
    
    var hasSearchController: Bool = false {
        didSet {
            if hasSearchController {
                
                //Setup SearchController
                self.searchController = ({
                    let controller = UISearchController(searchResultsController: nil)
                    controller.searchBar.sizeToFit()
                    controller.searchBar.barStyle = .black
                    controller.searchBar.returnKeyType = .search
                    controller.definesPresentationContext = false
                    controller.obscuresBackgroundDuringPresentation = false
                    UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
                    self.navigationItem.searchController = controller
                    
                    return controller
                })()
                
            }
            else {
                self.searchController = nil
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem?.tintColor = .white
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
    
    func setupSearchControllerDelegates(searchResultsUpdater: UISearchResultsUpdating, searchDelegate: UISearchBarDelegate) {
        searchController?.searchResultsUpdater = searchResultsUpdater
        searchController?.searchBar.delegate = searchDelegate
    }

    @objc func createAccountBtnClicked() {
        performSegue(withIdentifier: backToSignUpSegueIdentifier, sender: nil)
    }
    
    func constrainToContainerView() {
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        if let superview = self.view.superview {
        NSLayoutConstraint.activate([
            self.view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0),
            self.view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0),
            self.view.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0),
            self.view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0)
            ])
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
