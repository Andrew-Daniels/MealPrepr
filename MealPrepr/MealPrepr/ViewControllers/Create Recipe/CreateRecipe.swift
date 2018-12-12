//
//  CreateRecipe.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/10/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

private let createIngredientsIdentifier = "Create-Ingredients"
private let createUtensilsIdentifier = "Create-Utensils"
private let createInstructionsIdentifier = "Create-Instructions"
private let createPhotosIdentifier = "Create-Photos"

public let mainStoryboardIdentifier = "Main"

class CreateRecipe: MPViewController, MPTextFieldDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleTextField: MPTextField!
    @IBOutlet weak var caloriesTextField: MPTextField!
    @IBOutlet weak var servingsTextField: MPTextField!
    
    private enum Controller: Int {
        case Ingredients = 0
        case Utensils = 1
        case Instructions = 2
        case Photos = 3
    }
    
    private var viewControllers = [Controller: MPViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        
        titleTextField.delegate = self
        caloriesTextField.delegate = self
        servingsTextField.delegate = self
        
        let index = Controller(rawValue: segmentedControl.selectedSegmentIndex)
        presentChildVC(atIndex: index)
        segmentedControl.addTarget(self, action: #selector(segmentedControlIndexChanged), for: .valueChanged)
        
        let _ = titleTextField.becomeFirstResponder()   
    }
    
    func setupSegmentedControl() {
        segmentedControl.setTitle("Ingredients", forSegmentAt: 0)
        segmentedControl.setTitle("Utensils", forSegmentAt: 1)
        segmentedControl.setTitle("Instructions", forSegmentAt: 2)
        
        if (UIDevice.current.userInterfaceIdiom == .phone) {
            segmentedControl.insertSegment(withTitle: "Photos", at: 3, animated: true)
        }
        
    }
    
    private func createControllerForSelectedIndex(index: Controller?) -> MPViewController? {
        let main = UIStoryboard(name: mainStoryboardIdentifier, bundle: nil)
        guard let index = index else { return nil }
        var vcIdentifier: String!
        
        switch (index) {
            
        case .Ingredients:
            vcIdentifier = createIngredientsIdentifier
        case .Utensils:
            vcIdentifier = createUtensilsIdentifier
        case .Instructions:
            vcIdentifier = createInstructionsIdentifier
        case .Photos:
            vcIdentifier = createPhotosIdentifier
        }
        guard let vc = main.instantiateViewController(withIdentifier: vcIdentifier) as? MPViewController else {return nil}
        
        viewControllers[index] = vc
        
        return vc
    }
    
    private func presentChildVC(atIndex: Controller?) {
        guard let atIndex = atIndex else { return }
        var vc = viewControllers[atIndex]
        if vc == nil {
            vc = createControllerForSelectedIndex(index: atIndex)
        }
        
        guard let activeVC = vc else { return }
        addChild(activeVC)
        containerView.addSubview(activeVC.view)
        activeVC.constrainToContainerView()
        
        activeVC.didMove(toParent: self)
    }
    
    @objc func segmentedControlIndexChanged() {
        guard let index = Controller(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        presentChildVC(atIndex: index)
    }
    
    func mpTextFieldShouldReturn(textField: MPTextField) {
        if (textField == self.titleTextField) {
            let _ = self.caloriesTextField.becomeFirstResponder()
        }
        else if (textField == self.caloriesTextField) {
            let _ = self.servingsTextField.becomeFirstResponder()
        }
        else if (textField == self.servingsTextField) {
            let _ = self.servingsTextField.resignFirstResponder()
        }
    }
}
