//
//  Photos.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/12/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

private let photoCellIdentifier = "PhotoCell"

class Photos: MPViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PhotoCellDelegate, RecipeDelegate {
    
    @IBOutlet weak var collectionView: MPCollectionView!
    var images = [UIImage]()
    var recipe: Recipe?
    var readOnly: Bool = false
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    @IBOutlet var activeConstraintsDuringView: [NSLayoutConstraint]!
   
    @IBOutlet var inactiveConstraintsDuringView: [NSLayoutConstraint]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if UIDevice.current.userInterfaceIdiom == .pad {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.scrollDirection = .horizontal
        }
        if readOnly {
            addPhotoBtn.isHidden = true
            addPhotoBtn.isEnabled = false
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
        
        if let recipe = recipe {
            cell.imageView.image = recipe.photoAtIndex(index: indexPath.row)
            cell.deleteBtn.isHidden = true
            cell.deleteBtn.isEnabled = false
            recipe.delegate = self
        } else {
            cell.imageView.image = images[indexPath.row]
        }
        
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 8
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
    }
    @IBAction func addPhotoBtnClicked(_ sender: Any) {
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
    }
    
    override func viewDidLayoutSubviews() {
        if let _ = recipe {
            for c in activeConstraintsDuringView {
                if !c.isActive {
                    c.isActive = true
                }
            }
            for c in inactiveConstraintsDuringView {
                if c.isActive {
                    c.isActive = false
                }
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
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
