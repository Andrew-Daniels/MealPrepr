//
//  MPViewController.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/8/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

private let loadingVCSBIdentifer = "LoadingVC"

class MPViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AlertDelegate, ConnectionErrorViewDelegate {
    
    var account: Account!
    var searchController: UISearchController?
    var selectedImage: UIImage?
    var collectionViewCellWidth: CGFloat?
    private var loadingVC: Loading?
    let reachability = Reachability()!
    private var defaultLayoutMargins: UIEdgeInsets!
    var connectionErrorView: ConnectionErrorView!
    
    var hasSearchController: Bool = false {
        didSet {
            if hasSearchController {
                
                //Setup SearchController
                self.searchController = ({
                    let controller = UISearchController(searchResultsController: nil)
                    controller.searchBar.sizeToFit()
                    controller.searchBar.barStyle = .black
                    controller.searchBar.searchBarStyle = .minimal
                    controller.searchBar.returnKeyType = .search
                    controller.definesPresentationContext = true
                    controller.obscuresBackgroundDuringPresentation = false
                    controller.hidesNavigationBarDuringPresentation = true
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
        defaultLayoutMargins = self.view.layoutMargins
        connectionErrorView = ConnectionErrorView(parent: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
        }
        
        if let tabBarController = self.tabBarController, self.tabBarController is MPTabBarController {
            let t = tabBarController as! MPTabBarController
            
            t.connectionErrorView.setConnectionStatus(status: reachability.connection)
            connectionErrorView.setConnectionStatus(status: reachability.connection, containedInTabController: true)
            //self.setViewMargins(slideUp: true)
        } else {
            connectionErrorView.setConnectionStatus(status: reachability.connection)
        }
    }
    
    func handleErrorViewVisibility(visible: Bool) {
        setViewMargins(slideUp: visible)
    }
    
    private func setViewMargins(slideUp: Bool) {
        DispatchQueue.main.async {
            if slideUp {
                self.view.layoutMargins = UIEdgeInsets.init(top: self.view.layoutMargins.top, left: self.view.layoutMargins.left, bottom: self.view.layoutMargins.bottom + 50, right: self.view.layoutMargins.right)
                self.viewLayoutMarginsDidChange()
            } else {
                self.view.layoutMargins = self.defaultLayoutMargins
            }
        }
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
        guard let cellWidth = collectionViewCellWidth else { return UIEdgeInsets.zero }
        
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
    }

    @objc func createAccountBtnClicked() {
        performSegue(withIdentifier: backToSignUpSegueIdentifier, sender: nil)
    }
    
    func checkForGuestAccount() -> Bool {
        if self.account.userLevel == .Guest {
            MPAlertController.show(message: "You must sign in first before you can use this feature.", type: .CreateAccount, presenter: self)
            return true
        }
        return false
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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        guard let newImage = ImageHelper.resizeImage(image: image, withMaxDimension: 300) else {
            return
        }
        self.selectedImage = newImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func showImagePickerController() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let choosePhotoAction = UIAlertAction(title: "Choose Photo", style: .default) { (action) in
            self.showImagePickerController(type: .photoLibrary)
        }
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            self.showImagePickerController(type: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(takePhotoAction)
        alert.addAction(choosePhotoAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func showImagePickerController(type: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = type
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func startLoading(withText: String?) {
        let main = UIStoryboard(name: mainStoryboardIdentifier, bundle: nil)
        
        guard let vc = main.instantiateViewController(withIdentifier: loadingVCSBIdentifer) as? Loading else {return}
        if let loadingText = withText {
            vc.loadingText = loadingText
        }
        self.loadingVC = vc
        self.present(vc, animated: true, completion: nil)
    }
    
    func finishLoading(completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        self.loadingVC?.dismiss(animated: true) {
            completionHandler(true)
        }
    }
    
    func finishLoadingWithError(completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        self.loadingVC?.setError()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            // Put your code which should be executed with a delay here
            self.loadingVC?.dismiss(animated: true) {
                completionHandler(true)
            }
        })
    }
    
    func showRecipeDetails(recipe: Recipe) {
        let main = UIStoryboard.init(name: "Main", bundle: nil)
        let recipeDetailsVC = main.instantiateViewController(withIdentifier: recipeDetailsStoryboardIdentifier) as! RecipeDetails
        recipeDetailsVC.recipe = recipe
        recipeDetailsVC.navigationItem.title = recipe.title
        recipeDetailsVC.account = self.account
        self.navigationController?.pushViewController(recipeDetailsVC, animated: true)
        recipeDetailsVC.navigationController?.isNavigationBarHidden = false
    }
    
    func endEditing() {
        if self.isEditing {
            self.view.endEditing(true)
        }
    }
    
    func alertShown() {
        UIView.animate(withDuration: TimeInterval.init(exactly: 0.2)!) {
            self.tabBarController?.tabBar.isHidden = true
            self.extendedLayoutIncludesOpaqueBars = true
            self.navigationController?.view.layoutSubviews()
        }
    }
    
    func alertDismissed() {
        UIView.animate(withDuration: TimeInterval.init(exactly: 0.2)!) {
            self.tabBarController?.tabBar.isHidden = false
            self.extendedLayoutIncludesOpaqueBars = false
            self.navigationController?.view.layoutSubviews()
        }
    }
}
