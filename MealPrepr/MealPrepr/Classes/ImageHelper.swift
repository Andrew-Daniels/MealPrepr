//
//  ImageHelper.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/12/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation
import UIKit

class ImageHelper {
    
    public static func resizeImage(image: UIImage, withMaxDimension maxDimension: CGFloat) -> UIImage? {
        if (fmax(image.size.width, image.size.height) <= maxDimension) {
            return image;
        }
        
        let aspect = image.size.width / image.size.height
        var newSize = CGSize()
        
        if (image.size.width > image.size.height) {
            newSize = CGSize(width: maxDimension, height: maxDimension / aspect)
        }
        else
        {
            newSize = CGSize(width: maxDimension * aspect, height: maxDimension)
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        let newImageRect = CGRect(x: 0.0, y: 0.0, width: newSize.width, height: newSize.height)
        image.draw(in: newImageRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
