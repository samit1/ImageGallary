//
//  ViewController.swift
//  ImageGallary
//
//  Created by Sami Taha on 5/31/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import UIKit

class ImageGallaryViewController: UICollectionViewController {
    
    
    @IBOutlet var gallary: UICollectionView!
    var imageData = ImageGallary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        gallary.delegate = self
        //        gallary.dataSource = self
        gallary.dragDelegate = self
        gallary.dropDelegate = self
        
        loadWithTest()
        
    }
    
    private func loadWithTest() {
        for x in 1...30 {
            
            var url = "https://placebear.com/g/640/48" + String(x)
            var data = imageItem(widthToHeightRatio: 1, url: URL(string: url)! )
            imageData.appendToEnd(item: data)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: CollectionView Rows and Columns
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.gallery.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /// Check the cell is the of type ImageCollectionViewCell
        if let cell = gallary.dequeueReusableCell(withReuseIdentifier: "DraggedImage", for: indexPath) as? ImageCollectionViewCell {
            cell.url = imageData.gallery[indexPath.item].url!
            return cell
        }
            
        else {
            let cell = gallary.dequeueReusableCell(withReuseIdentifier: "Placeholder", for: indexPath)
            return cell
        }
    }
    
    
}


private struct Identifiers {
    static let imageViewCell = "ImageCVC"
    static let imageViewCellPlaceHolder = "ImageCVCPlaceholder"
}


// UICollectionViewDragDelegate, UICollectionViewDropDelegate
extension ImageGallaryViewController : UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        print("hello")
    }
    

    /// Specify the type of data which can be dropped
    /// The data must be a URL and image
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == gallary
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(row: 0, section: 0)
//
//        for item in coordinator.items {
//
//            /// Check if a local drop
//            if let sourceIndexPath = item.sourceIndexPath {
//                //
//            }
//
//
//            /// Otherwise the drop is from elsewhere
//            else {
//                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (provider, error) in
//                    DispatchQueue.main.async {
//                        if let attributedString = provider as? NSAttributedString {
//                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
//                                self.emojis.insert(attributedString.string, at: insertionIndexPath.item)
//                            })
//                        } else {
//                            placeholderContext.deletePlaceholder()
//                        }
//            }
//
//        }
//
//
//    }
}

extension ImageGallaryViewController : UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if let img = (gallary.cellForItem(at: indexPath) as? ImageCollectionViewCell)?.imageView?.image {
            
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: img ))
            dragItem.localObject = dragItem
            return [dragItem]
        }
        return []
    }
}


extension ImageGallaryViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 640, height: 480)
    }
}
