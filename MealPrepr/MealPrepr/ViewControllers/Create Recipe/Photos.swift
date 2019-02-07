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
    var images = [UIImage]()
    @IBOutlet weak var roundedUIView: RoundedUIView!
    
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
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let recipe = recipe {
            return recipe.photoPaths.count
        }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as! PhotoCell
        
        if let r = recipe, let image = r.photoAtIndex(index: indexPath.row) {
            cell.imageView.image = image
            r.recipeDelegate = self
            self.images.insert(image, at: indexPath.row)
        } else {
            cell.imageView.image = images[indexPath.row]
        }
        
        if readOnly {
            cell.deleteBtn.isHidden = true
            cell.deleteBtn.isEnabled = false
        }
        
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 8
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if readOnly {
            return CGSize.init(width: 200, height: 200)
        }
        let iv = UIImageView()
        if let recipe = recipe {
            iv.image = recipe.photoAtIndex(index: indexPath.row)
        } else {
            iv.image = images[indexPath.row]
        }
        iv.sizeToFit()
        let size = iv.frame.size
        return size
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return super.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: section)
    }
    
    func addImage(image: UIImage) {
        images.append(image)
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
            self.images.remove(at: path.row)
            self.collectionView.deleteItems(at: [path])
        }
    }
    
    func photoDownloaded(sender: Recipe) {
        
    }
    
    func photoDownloaded(photoPath index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.reloadItems(at: [indexPath])
//        guard let images = recipe?.photos else { return }
//        self.images = images
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
