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
        guard lhs.url != nil && lhs.heightMultipleToWidth != nil
            && rhs.url != nil && rhs.heightMultipleToWidth != nil else {return false}
        
        
        return lhs.heightMultipleToWidth == rhs.heightMultipleToWidth
            && lhs.url == rhs.url
    }
    
    private (set) var heightMultipleToWidth: Double?
    private (set) var url : URL?
    
    init(heightMultipleToWidth : Double, url : URL) {
        self.heightMultipleToWidth = heightMultipleToWidth
        self.url = url
    }
    
    
}

typealias images = [ImageItem]
struct ImageGallaryItem {
    let galleryUUID = NSUUID().uuidString

    
    private (set) var gallery = images() {didSet {
        //gallery.forEach({print($0.description)})
        }
    }
    
    mutating func insert(item: ImageItem, at index: Int) {
        guard gallery.indices.contains(index) else {
            appendToEnd(item: item)
            return
            
        }
        
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
        return("widthToHeightRatio:  + \(heightMultipleToWidth) + /n + url: + \(url) ")
    }
    
    
}
