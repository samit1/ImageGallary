//
//  ImageViewController.swift
//  ImageGallary
//
//  Created by Sami Taha on 6/10/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    /// Scrollview on screen
    @IBOutlet weak var imgScrollView: UIScrollView! {
        didSet {
            self.imgScrollView.minimumZoomScale = 1/25
            self.imgScrollView.maximumZoomScale = 1.0
            self.imgScrollView.delegate = self
            
        }
    }
    
    /// Image to be displayed on screen
    @IBOutlet weak var imageView: ImageLoader!
    /// URL of image. Image has to be fetched each time

    var imgURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = imgURL {
            imageView.setImgForURL(url: url)
        }
        // Do any additional setup after loading the view.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
