//
//  GallaryStoreModel.swift
//  ImageGallary
//
//  Created by Sami Taha on 6/5/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import Foundation
typealias galleries = [GallaryStoreItem]
protocol GalleryListDelegate : class {
    func viewableGalleriesDidChange(viewableGalleries : galleries)
    func recentlyDeletedGalleriesDidChange(recentlyDeleted : galleries)
}

class GallaryStoreItem  {
    var gallaryname : String?
    var gallaryContents = ImageGallaryItem()
}

class GalleriesModel {
    private var viewableGalleries = [GallaryStoreItem]().uniquified {didSet {delegate?.viewableGalleriesDidChange(viewableGalleries: viewableGalleries) }}
    private var recentltyDeletedGalleries = [GallaryStoreItem]().uniquified {didSet { delegate?.recentlyDeletedGalleriesDidChange(recentlyDeleted: recentltyDeletedGalleries)}}
    
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
    func requestToDeleteGallary(gallary : GallaryStoreItem ) {
        
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
    
    func requestNameUpdate(for gallaryItem: GallaryStoreItem, with nameAfterChange: String) {
        
        if let gallaryIndex = viewableGalleries.index(of: gallaryItem) {
            viewableGalleries[gallaryIndex].gallaryname = nameAfterChange
            return
        }
        
        if let gallaryIndex = recentltyDeletedGalleries.index(of: gallaryItem) {
            recentltyDeletedGalleries[gallaryIndex].gallaryname = nameAfterChange
            return
        }
        let newItem = GallaryStoreItem()
        newItem.gallaryname = nameAfterChange
        viewableGalleries.append(newItem)    
    }
}


/// GallaryStoreItem is considered equatable based on if the non-nil names do not equal each other
extension GallaryStoreItem : Equatable {
    static func == (lhs: GallaryStoreItem, rhs: GallaryStoreItem) -> Bool {
        guard lhs.gallaryname != nil && rhs.gallaryname != nil else {return false}
        if lhs.gallaryname == rhs.gallaryname {return true}
        return false
    }
    
    
}

