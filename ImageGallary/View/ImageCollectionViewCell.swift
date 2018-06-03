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

    
    private (set) var url : URL?
    
    func configureCell(url : URL) {
        self.url = url
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let urlContents = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                // TODO: , url == self?.imageURL maybe add this here
                if let imageData = urlContents, url == self?.url   {
                    self?.imageView?.image = UIImage(data: imageData)
                    
                }
            }
        }
    }
    
}
