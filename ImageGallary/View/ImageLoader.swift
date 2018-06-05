//
//  aSyncImgLoader.swift
//  ImageGallary
//
//  Created by Sami Taha on 6/5/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import Foundation
import UIKit
class ImageLoader : UIImageView {
    var imgURL : URL?
    func setImgForURL(url : URL) {
        self.image = nil
        
        /// Create a copy of the image URL. Used to later validate asynchronous result
        imgURL = url
        
        DispatchQueue.global(qos: .userInitiated).async {
            let urlContents = try? Data(contentsOf: url)
            
            DispatchQueue.main.async { [weak self] in
                if let imageData = urlContents, url == self?.imgURL, let img = UIImage(data: imageData)   {
                    self?.image = img
                }
            }
        }
        
    }
}
