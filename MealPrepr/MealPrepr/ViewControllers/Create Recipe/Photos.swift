//
//  Photos.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/12/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

private let photoCellIdentifier = "PhotoCell"

class Photos: MPCreateRecipeChildController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PhotoCellDelegate, RecipeDelegate {
    
    @IBOutlet weak var collectionView: MPCollectionView!
    var images = [Int: UIImage]()
    var hasLoadedImagesFromRecipe: Bool = false
    @IBOutlet weak var roundedUIView: RoundedUIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if UIDevice.current.userInterfaceIdiom == .pad {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.scrollDirection = .horizontal
        }
        
        if readOnly {
            roundedUIView.hasEffectView = false
        }
        
        loadImagesFromRecipe()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if readOnly {
            recipe?.recipeDelegate = self
            return
        }
        
        if !hasLoadedImagesFromRecipe {
            loadImagesFromRecipe()
        }
    }
    
    func loadImagesFromRecipe() {
        if let r = recipe, images.count < r.photoPaths.count {
            guard let paths = r.photoPaths else { return }
            
            self.addBtn?.isEnabled = false
            
            for (index, path) in paths.enumerated() {
                FirebaseHelper().downloadImage(atPath: path, renderMode: .alwaysOriginal) { (image) in
                    self.images[index] = image
                    if self.images.count == paths.count {
                        self.addBtn?.isEnabled = true
                        self.activityIndicator?.stopAnimating()
                        self.hasLoadedImagesFromRecipe = true
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if readOnly {
            return recipe?.photoPaths?.count ?? 0
        }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as! PhotoCell
        
        if readOnly {
            cell.deleteBtn.isHidden = true
            cell.deleteBtn.isEnabled = false
            
            if let image = recipe?.photoAtIndex(index: indexPath.row) {
                cell.imageView.image = image
            }
        } else if let image = images[indexPath.row] {
            cell.imageView.image = image
        }
        
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 4
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if readOnly {
            return CGSize.init(width: 200, height: 200)
        }
        let iv = UIImageView()
        iv.image = images[indexPath.row]
        iv.sizeToFit()
        let size = iv.frame.size
        return size
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return super.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: section)
    }
    
    func addImage(image: UIImage) {
        images[images.count] = image
        collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    @IBAction func addPhotoBtnClicked(_ sender: Any) {
        endEditing()
        showImagePickerController()
    }
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        super.imagePickerController(picker, didFinishPickingMediaWithInfo: info)
        if let image = self.selectedImage {
            addImage(image: image)
        }
    }
    
    func deleteBtnPressed(sender: PhotoCell) {
        let indexPath = self.collectionView.indexPath(for: sender)
        if let path = indexPath {
            self.images.removeValue(forKey: path.row)
            var newImages = [Int: UIImage]()
            for (index, image) in images {
                if index > path.row {
                    newImages[index - 1] = image
                } else {
                    newImages[index] = image
                }
            }
            self.images = newImages
            self.collectionView.deleteItems(at: [path])
        }
    }
    
    func photoDownloaded(sender: Recipe) {
        
    }
    
    func photoDownloaded(photoPath index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.reloadItems(at: [indexPath])
        guard let images = recipe?.photos else { return }
        self.images = images
    }
    
    func recipeDeleted(GUID: String) {
        
    }
    
//    override func didMove(toParent parent: UIViewController?) {
//        if parent is RecipeDetails {
//            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//            layout.scrollDirection = .horizontal
//        }
//    }
    
    
//    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return super.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: section)
//    }
    
    /*
     // MARK: - Naviga@objc(collectionView:layout:insetForSectionAtIndex:) tion

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
