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
struct ImageItem : Equatable {
    static func == (lhs: ImageItem, rhs: ImageItem) -> Bool {
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

typealias images = [ImageItem]
struct ImageGallary {
    
    private (set) var gallery = images() {didSet {
        gallery.forEach({print($0.description)})
        }
    }
    
    mutating func insert(item: ImageItem, at index: Int) {
        guard gallery.indices.contains(index) else {return}
        
        gallery.insert(item, at: index)
    }
    
    mutating func appendToEnd(item: ImageItem) {
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
}


extension ImageItem : CustomStringConvertible {
    var description: String {
        return("widthToHeightRatio:  + \(widthToHeightRatio) + /n + url: + \(url) ")
    }
    
    
}
