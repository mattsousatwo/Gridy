//
//  SlicingImages.swift
//  Gridy
//
//  Created by Matthew Sousa on 1/10/19.
//  Copyright © 2019 Matthew Sousa. All rights reserved.
//

import UIKit

class Slicing {
    
    // property to hold sliced images for tiles 
    var slicedImageArray: [[UIImage]] = []
    
    // create an array of slices from an image using the desired amount of columns and rows, then store that array inside another array
    func sliceImage(for image: UIImage, row: Int, column: Int) -> [[UIImage]] {
        
        // divide image height by number of rows as! CGFloat
        let height = (image.size.height) / CGFloat (row)
        let width = (image.size.width) / CGFloat (column)
        
        // scale conversion factor is needed as UIImage makes use of "points" whereas CGImage uses pixels
        let scale = (image.scale)
        
        // empty array of arrays of images
        var imageArray = [[UIImage]]()
        
        // for each in 0 ... number of rows
        for y in 0..<row {
            
            // empty array
            var yArray = [UIImage]()
            
            // for each in 0 ... number of columns
            for x in 0..<column {
                
                // creating a bitmap of an image with specific options
                // size = width & height, opacity = false, scale = 0
                UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
                
                // creating a slice of the image
                let i = image.cgImage?.cropping(to: CGRect.init(x: CGFloat(x) * width * scale, y:  CGFloat(y) * height * scale , width: width * scale, height: height * scale)  )
                
                // add slice of image
                let newImage = UIImage.init(cgImage: i!)
                
                // add newImage to yArray
                yArray.append(newImage)
                
                // end drawing image
                UIGraphicsEndImageContext();
                
            }
            
            // add yArray to imageArray
            imageArray.append(yArray)
            
        }
        
        // return imageArray
      return imageArray  
        
    }
    
    
    func removeImages(from images: inout [[UIImage]]) {
        if images.count != 0 {
            print("removing slices for new image \n")
            images.removeAll()
            
        } else {
        
        print("imageArray.count = 0 \n")
            
        }
    }

    
// Displaying Slices Methods
    
    // Methods to easily set position for UIView
    func getXViewPosition(from view: UIView) -> CGFloat {
        // x: 6
        let xOffsetEquation = view.frame.origin.x + 6
        return xOffsetEquation
    }
    
    func getYViewPosition(from view: UIView) -> CGFloat {
        // y: 68
        let yOffsetEquation = view.frame.origin.y + 68
        return yOffsetEquation
    }
    
   
    
    
}


