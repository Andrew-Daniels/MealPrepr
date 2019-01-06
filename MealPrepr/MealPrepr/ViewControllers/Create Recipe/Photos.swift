//
//  Photos.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/12/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import UIKit

private let photoCellIdentifier = "PhotoCell"

class Photos: MPViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PhotoCellDelegate {
    
    @IBOutlet weak var collectionView: MPCollectionView!
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if UIDevice.current.userInterfaceIdiom == .pad {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.scrollDirection = .horizontal
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as! PhotoCell
        cell.imageView.image = images[indexPath.row]
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 8
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let iv = UIImageView()
        iv.image = images[indexPath.row]
        iv.sizeToFit()
        let size = iv.frame.size
        return size
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
