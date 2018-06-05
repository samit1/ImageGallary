//
//  ImageCollectionViewCell.swift
//  ImageGallary
//
//  Created by Sami Taha on 6/3/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: ImageLoader!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var url : URL! {
        didSet {
            imageView.setImgForURL(url: url)
        }
    }
    

    
}
