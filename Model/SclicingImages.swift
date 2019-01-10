//
//  SlicingImages.swift
//  Gridy
//
//  Created by Matthew Sousa on 1/10/19.
//  Copyright © 2019 Matthew Sousa. All rights reserved.
//

import UIKit

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
            let i = image.cgImage?.cropping(to: CGRect.init(x: CGFloat(x) * width * scale, y: CGFloat(y) * height * scale , width: width * scale, height: height * scale) )
         
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





func createNewImage(with imageArray: [[UIImage]], from imageView: UIImageView) {
    
    // rows == number of arrays in imageArray
    let row = imageArray.count
    // column == number of images in the first array in imageArray
    let column = imageArray[0].count
    
    //  height = imageView Height / row
    let height = (imageView.frame.size.height) / CGFloat (row)
    // width = imageView Width / column
    let width = (imageView.frame.size.width) / CGFloat (column)
    
    // Create a bitmap of imageView, size = imageView height x imageView width
    UIGraphicsBeginImageContext(CGSize.init(width: imageView.frame.size.width, height: imageView.frame.size.height))
    
    // for each in 0 ... number of rows
    for y in 0..<row {
        
        // for each in 0 ... number of columns
        for x in 0..<column {
            
            // newImage ==
            let newImage = imageArray[y][x]
            
            // creating the newImage on screen
            newImage.draw(in: CGRect.init(x: CGFloat(x) * width, y: CGFloat(y) * height, width: width - 1, height: height - 1))
        }
    }
    
    // create new Image of the original image of sliced up images all together to appear as the original image
    let originalImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    
    // set slices as imageView.image
    imageView.image = originalImage
    
}
