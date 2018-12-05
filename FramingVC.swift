//
//  FramingVC.swift
//  Gridy
//
//  Created by Matthew Sousa on 11/28/18.
//  Copyright © 2018 Matthew Sousa. All rights reserved.
//

import UIKit

class FramingVC: UIViewController, UIScrollViewDelegate {

    var imageHolder2 = UIImage() 
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    
    
     
      //  1.1 Add transparant overlay with cutout as subView of UIScrollView
      //  1.2 Keep Grid as seperate image
      //          - Keep Grid as subView of UIImageView ontop of UIImageView
      //          - (Or create transparant overlay with cutout, with grid inside cutout. Avoids size differences, onee image to resize insted of two)
     
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // assigning selected || taken photo to the imageView
        selectedImageView.image = imageHolder2
        
        // setting the zoomable scale for the scrollView
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        scrollView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    // telling the scollView which image we are going to zoom in on
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return selectedImageView
    }
    
    // Whate we are going to do after the image is done being zoomed in on
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        // return image at selected scale
        return selectedImageView.contentScaleFactor = scale
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
