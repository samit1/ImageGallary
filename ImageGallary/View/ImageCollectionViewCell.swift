//
//  ImageCollectionViewCell.swift
//  ImageGallary
//
//  Created by Sami Taha on 6/3/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var img : UIImage! {
        didSet {
            imageView?.image = img 
        }
    }
    

    
}
