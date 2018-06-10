//
//  GallaryStoreModel.swift
//  ImageGallary
//
//  Created by Sami Taha on 6/5/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import Foundation
typealias galleries = [ImageGallary]
protocol GalleryListDelegate : class {
    func viewableGalleriesDidChange(viewableGalleries : galleries)
    func recentlyDeletedGalleriesDidChange(recentlyDeleted : galleries)
}

class GalleriesModel  {
    
    private var viewableGalleries = galleries().uniquified {didSet {delegate?.viewableGalleriesDidChange(viewableGalleries: viewableGalleries) }}
    private var recentltyDeletedGalleries = galleries().uniquified {didSet { delegate?.recentlyDeletedGalleriesDidChange(recentlyDeleted: recentltyDeletedGalleries)}}
    
    init() {
        if viewableGalleries.isEmpty {
            addGalary()
        }
    }
    
    
    weak var delegate : GalleryListDelegate?
    
    func requestViewableGalleries() {
        delegate?.viewableGalleriesDidChange(viewableGalleries: viewableGalleries)
    }
    
    func requestRecentlyDeletedGallries() {
        delegate?.recentlyDeletedGalleriesDidChange(recentlyDeleted: recentltyDeletedGalleries)
    }
    
    /// - parameter gallery : the gallary that should be deleted
    /// - NOTE: The gallary is first checked to see if it can be removed from a viewable gallery
    /// it then checks to see if a gallery should be removed from a recently deleted gallery
     func requestToDeleteGallary(gallary : ImageGallary ) {
        
        /// Check to see if gallery should be moved to recently deleted or removed from recently deleted
        if viewableGalleries.contains(gallary) {
            let gallaryToMove = viewableGalleries.remove(at: viewableGalleries.index(of: gallary)!)
            recentltyDeletedGalleries.append(gallaryToMove)
            return
        } else if recentltyDeletedGalleries.contains(gallary) {
            recentltyDeletedGalleries.remove(at: recentltyDeletedGalleries.index(of: gallary)!)
            return
        }
    }
    
    func requestToUndeleteGallary(gallary : ImageGallary) {
        guard recentltyDeletedGalleries.contains(gallary) else {return}
        let gallaryToMove = recentltyDeletedGalleries.remove(at: recentltyDeletedGalleries.index(of: gallary)!)
        viewableGalleries.append(gallaryToMove)
    }
    
    
     func requestNameUpdate(for gallaryItem: ImageGallary, with nameAfterChange: String) {
        
        if let gallaryIndex = viewableGalleries.index(of: gallaryItem) {
            viewableGalleries[gallaryIndex].galleryName = nameAfterChange
            return
        }
        
        if let gallaryIndex = recentltyDeletedGalleries.index(of: gallaryItem) {
            recentltyDeletedGalleries[gallaryIndex].galleryName = nameAfterChange
            return
        }
        var newItem = ImageGallary()
        newItem.galleryName = nameAfterChange
        viewableGalleries.append(newItem)    
    }
    
     func requestGallaryContentsUpdate(for gallary: ImageGallary) {
        if let index = viewableGalleries.index(of: gallary) {
            viewableGalleries[index] = gallary
        }
    }
    
     func addGalary() {
        var newItem = ImageGallary()
        newItem.galleryName = "Title " + String(viewableGalleries.count + recentltyDeletedGalleries.count + 1)
        viewableGalleries.append(newItem)
    }
}
    


