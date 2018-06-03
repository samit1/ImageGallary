//
//  ImageItem.swift
//  ImageGallary
//
//  Created by Sami Taha on 5/31/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import Foundation

/// Data structure to image data
/// Implement Equatable to make comarisons easier
struct imageItem : Equatable {
    static func == (lhs: imageItem, rhs: imageItem) -> Bool {
        guard lhs.url != nil && lhs.widthToHeightRatio != nil
            && rhs.url != nil && rhs.widthToHeightRatio != nil else {return false}
        
        
        return lhs.widthToHeightRatio == rhs.widthToHeightRatio
            && lhs.url == rhs.url
    }
    
    private (set) var widthToHeightRatio: Double?
    private (set) var url : URL?
    
    init(widthToHeightRatio : Double, url : URL) {
        self.widthToHeightRatio = widthToHeightRatio
        self.url = url
    }
    
    
}

typealias images = [imageItem]
struct ImageGallary {
    
    private (set) var gallery = images()
    
    mutating func insert(item: imageItem, at index: Int) {
        guard gallery.indices.contains(index) else {return}
        
        gallery.insert(item, at: index)
    }
    
    mutating func appendToEnd(item: imageItem) {
        guard !gallery.contains(item) else {return}
        gallery.append(item)
    }
    
    mutating func removeAt(at index: Int) {
        guard gallery.indices.contains(index) else {return}
        gallery.remove(at: index)
    }
    
    mutating func swapIndices(itemIndex1 : Int, itemIndex2: Int) {
        guard gallery.indices.contains(itemIndex1)
            && gallery.indices.contains(itemIndex2) && itemIndex1 != itemIndex2 else {return}
        
        
        gallery.swapAt(itemIndex1, itemIndex2)
    }
    
//
//    /// Fetch a bag of bits. The caller can choose whether it wants to convert the data type
//    /// Which queue to call on is up to the caller
//
//    func fetchImageData(at index: Int) -> Data? {
//        guard gallery.indices.contains(index) else {return nil}
//
//        if let url = gallery[index].url {
//            let urlContents = try? Data(contentsOf: url.imageURL)
//            return urlContents
//        }
//        return nil
//    }
//
}
