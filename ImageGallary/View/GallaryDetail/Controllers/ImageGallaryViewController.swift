//
//  ViewController.swift
//  ImageGallary
//
//  Created by Sami Taha on 5/31/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import UIKit

class ImageGallaryViewController: UICollectionViewController {
    
    // MARK: Properties
    @IBOutlet var gallary: UICollectionView!
    
    var gallaryStore : GalleriesModel? {
        didSet {
            gallary?.reloadData()
        }
    }
    
    /// Images displayed on screen (if any)
    var imageData = ImageGallary() {
        didSet {
            gallaryStore?.requestGallaryContentsUpdate(for: imageData)
        }
    }
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        gallary.dragDelegate = self
        gallary.dropDelegate = self
        
        self.title = imageData.galleryName
    }
    
    var baseURL : String? {didSet {
        loadWithTest()
        }
    }
    
    private func loadWithTest() {
        for x in 1...30 {
            guard baseURL != nil else {return}
            let url = baseURL! + String(x)
            let data = ImageItem(heightMultipleToWidth: 1, url: URL(string: url)! )
            imageData.appendToEnd(item: data)
        }
    }
    
    
    
    // MARK: CollectionView Rows and Columns
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.gallery.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let placeholder = gallary.dequeueReusableCell(withReuseIdentifier: "Placeholder", for: indexPath)
        guard imageData.gallery.indices.contains(indexPath.item) else {return placeholder}
        guard let url = imageData.gallery[indexPath.item].url else {return placeholder}
        
        if let cell = gallary.dequeueReusableCell(withReuseIdentifier: "DraggedImage", for: indexPath) as? ImageCollectionViewCell {
            cell.url = url
            addDoubleTapGesture(to: cell)
            return cell
        }
        
        return placeholder
    }
    
    // MARK: Gestures
    
    func addDoubleTapGesture(to cell: ImageCollectionViewCell) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(wasDoubleTapped))
        gesture.numberOfTapsRequired = 2
        cell.addGestureRecognizer(gesture)
    }
    
    @objc func wasDoubleTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let tapLocation = sender.location(in: self.gallary)
            if let tapIndexPath = self.gallary.indexPathForItem(at: tapLocation) {
                if let tappedItem = self.gallary.cellForItem(at: tapIndexPath) as? ImageCollectionViewCell {
                    performSegue(withIdentifier: SegueIdentifier.showImage, sender: tappedItem)
                }
            }
            
        }
    }
    
    //MARK : Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? ImageCollectionViewCell else {return}
        
        if let path = gallary.indexPath(for: sender) {
            if let identifier = segue.identifier {
                if identifier == SegueIdentifier.showImage {
                    if let destinationVC = segue.destination.contents as? ImageViewController {
                        
                        destinationVC.imgURL = imageData.gallery[path.row].url
                    }
                }
            }
            
        }
    }
    
}


// MARK: CollectionViewDropDelegate

// UICollectionViewDragDelegate, UICollectionViewDropDelegate

extension ImageGallaryViewController : UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        /// There are two differenct drop scenarios. The drop can either be an internal drag and drop from the collectionView
        /// or the drop is from an external source.
        
        /// If the drag and drop if from the collectionView, then we notify our model that there was a rearrangement.
        var destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(row: 0, section: 0)
        
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
                                let imgItem = ImageItem(heightMultipleToWidth: 1.0, url: urlImage)
                                self.gallary.reloadData()
                                self.imageData.insert(item: imgItem, at: destinationIndexPath.item)
                                
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
        return  session.canLoadObjects(ofClass: NSURL.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == gallary
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
}

// MARK: CollectionViewDragDelegate

extension ImageGallaryViewController : UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard imageData.gallery.indices.contains(indexPath.item) else {return []}
        var dragItems = [UIDragItem]()
        
        if let url = imageData.gallery[indexPath.item].url {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: url as NSItemProviderWriting))
            dragItem.localObject = dragItem
            dragItems.append(dragItem)
        }
        
        if let wXh = imageData.gallery[indexPath.item].heightMultipleToWidth {
            if let wxhD = wXh as? NSItemProviderWriting {
                let dragItem = UIDragItem(itemProvider: NSItemProvider(object: wxhD))
                dragItem.localObject = dragItem
                dragItems.append(dragItem)
            }
        }
        
        return dragItems
        
    }
}

// MARK: CollectionViewFlowLayoutDelegate
extension ImageGallaryViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard imageData.gallery.indices.contains(indexPath.item) else {return CGSize.zero}
        let width = collectionView.bounds.width / 4
        let heightMultiple = imageData.gallery[indexPath.item].heightMultipleToWidth
        let height = heightMultiple != nil ?  width * CGFloat(heightMultiple!) : 0
        return CGSize(width: width, height: height)
        
    }
    
}



extension ImageGallaryViewController : UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
}

// MARK: Constants
private struct SegueIdentifier {
    static let showImage = "showImage"
}

