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
            
            let url = "https://placebear.com/g/640/48" + String(x)
            let data = ImageItem(widthToHeightRatio: 1, url: URL(string: url)! )
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
        
        let placeholder = gallary.dequeueReusableCell(withReuseIdentifier: "Placeholder", for: indexPath)
        guard let url = imageData.gallery[indexPath.item].url else {return placeholder}
        
        if let cell = gallary.dequeueReusableCell(withReuseIdentifier: "DraggedImage", for: indexPath) as? ImageCollectionViewCell {
            cell.activityIndicator.startAnimating()
            cell.img = nil 
            DispatchQueue.global(qos: .userInitiated).async {
                let urlReturn = url
                let urlContents = try? Data(contentsOf: urlReturn)
                
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == urlReturn, let img = UIImage(data: imageData)   {
                        cell.img = img
                        cell.activityIndicator.stopAnimating()
                    }
                }
            }
            return cell
        }
        return placeholder
    }
    
    
    
}

// MARK: CollectionViewDropDelegate

// UICollectionViewDragDelegate, UICollectionViewDropDelegate

extension ImageGallaryViewController : UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        /// There are two differenct drop scenarios. The drop can either be an internal drag and drop from the collectionView
        /// or the drop is from an external source.
        
        /// If the drag and drop if from the collectionView, then we notify our model that there was a rearrangement.
        guard let destinationIndexPath = coordinator.destinationIndexPath else {return}
        for item in coordinator.items {
            if let beginIndex = item.sourceIndexPath {
                collectionView.performBatchUpdates({
                    imageData.swapIndices(itemIndex1: beginIndex.item, itemIndex2: destinationIndexPath.item)
                }, completion: {(completion) in
                    collectionView.reloadItems(at: [beginIndex, destinationIndexPath])
                    })
            }

            /// If the drag originates from ourside of the collectionView (i.e., an external source), then we place a Placeholder to put the data in.
            else {
                /// Add a placeholder at the destinationIndex
                let placeholderContext = coordinator.drop(
                    item.dragItem,
                    to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "Placeholder"))
                
                /// Asynchonously go get the data and insert
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self, completionHandler: { (provider, error) in
                    DispatchQueue.main.async {
                        if let url = provider as? URL {
                            placeholderContext.commitInsertion(dataSourceUpdates: {[unowned self] insertionIndexPath in
                                let urlImage = url.imageURL
                                let imgItem = ImageItem(widthToHeightRatio: 1.0, url: urlImage)
                                self.imageData.insert(item: imgItem, at: destinationIndexPath.item)
                                self.gallary.reloadItems(at: [destinationIndexPath])
                                print("interesting")
                            })
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                })
                
                
            }
        }
    }
    
    
    /// Specify the type of data which can be dropped
    /// The data must be a URL and image
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        //print(session.canLoadObjects(ofClass: NSURL.self))
        print(session.canLoadObjects(ofClass: UIImage.self))
        return  session.canLoadObjects(ofClass: UIImage.self) && session.canLoadObjects(ofClass: NSURL.self)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == gallary
        print("Hi")
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
}

// MARK: CollectionViewDragDelegate

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

// MARK: CollectionViewFlowLayoutDelegate
extension ImageGallaryViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 320, height: 240)
    }
}



extension ImageGallaryViewController : UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
}
