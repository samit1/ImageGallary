//
//  GallaryStoreTableViewController.swift
//  ImageGallary
//
//  Created by Sami Taha on 6/5/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import UIKit

class GallaryStoreViewController: UIViewController, UIGestureRecognizerDelegate {
    
    /// TableView of galleries
    @IBOutlet weak var gallaryTable: UITableView!
    
    /// Add a new gallary
    @IBAction func addGallaryTap(_ sender: UIBarButtonItem) {
        gallaryModel?.addGalary()
    }
    
    /// The gallary store
    var gallaryModel : GalleriesModel? {
        didSet {
            gallaryTable?.reloadData()
        }
    }
    
    /// The viewable galleries
    fileprivate var _galleries = [ImageGallary]() {didSet {
        self.gallaryTable?.reloadData()
        }
    }
    
    /// Recently deleted galeries
    fileprivate var _recentlyDeletedGalleries = [ImageGallary]() {didSet {
        if _recentlyDeletedGalleries.count == 0 && _galleries.count == 0 {gallaryModel?.addGalary()}
        self.gallaryTable?.reloadData()
        }
    }
    
    /// Viewable galeries and recently deleted galleries.
    fileprivate var allGalleries : [[ImageGallary]] {
        return [_galleries, _recentlyDeletedGalleries]
    }
    
    /// The IndexPath of the last selected cell
    private var lastSelectedPath : IndexPath?
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        gallaryTable.delegate = self
        gallaryTable.dataSource = self
        gallaryModel?.delegate = self
        setupTable()
    }
    private func setupTable() {
        gallaryModel?.requestViewableGalleries()
        gallaryModel?.requestRecentlyDeletedGallries()
    }
    
    /// Single and double tap gesture recognition
    private func addTapGestures(for cell: GallaryNameTableViewCell) {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapSegue))
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapSegue))
        singleTap.numberOfTapsRequired = 1
        doubleTap.numberOfTapsRequired = 2
        cell.addGestureRecognizer(singleTap)
        cell.addGestureRecognizer(doubleTap)
        singleTap.require(toFail: doubleTap)
    }
    
    /// Single tap gesture to segue from cell
    @objc func singleTapSegue(_ sender : UITapGestureRecognizer) {
        
        if let cell = findCellFor(sender: sender) {
            performSegue(withIdentifier: SegueIdentifier.showGallaryDetail, sender: cell)
        }
    }
    
    /// Double tap gesture to edit cell
    @objc func doubleTapSegue(_ sender : UITapGestureRecognizer) {
        
        if let cell = findCellFor(sender: sender) {
            cell.isEditing = true
        }
        
    }
    
    /// Helper method to find cell that had a tap gesture
    private func findCellFor(sender: UITapGestureRecognizer) -> GallaryNameTableViewCell? {
        if sender.state == UIGestureRecognizerState.ended {
            let tapLocation = sender.location(in: self.gallaryTable)
            if let tapIndexPath = self.gallaryTable.indexPathForRow(at: tapLocation) {
                if let tappedCell = self.gallaryTable.cellForRow(at: tapIndexPath) as? GallaryNameTableViewCell {
                    return tappedCell
                }
            }
        }
        return nil
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? GallaryNameTableViewCell else {return}
        
        if let cellSent = gallaryTable.indexPath(for: sender), cellSent.section == 0 {
            
            if let identifier = segue.identifier {
                if identifier == SegueIdentifier.showGallaryDetail {
                    if let destinationVC = segue.destination.contents as? ImageGallaryViewController {
                        destinationVC.imageData = allGalleries[cellSent.section][cellSent.row]
                        destinationVC.gallaryStore = gallaryModel
                    }
                }
            }
        }
    }
}

// MARK: Tableview Data Source and Delegates
extension GallaryStoreViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GallaryNameCell", for: indexPath)
        if let galleryCell = cell as? GallaryNameTableViewCell {
            galleryCell.textField.text = allGalleries[indexPath.section][indexPath.row].galleryName
            galleryCell.delegate = self
            galleryCell.isEditing = false
            addTapGestures(for: galleryCell)
        }
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allGalleries.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allGalleries[section].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let last = lastSelectedPath, last != indexPath {
            if  let cell = gallaryTable.cellForRow(at: last) as? GallaryNameTableViewCell {
                cell.isEditing = false
            }
        }
        lastSelectedPath = indexPath
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            gallaryModel?.requestToDeleteGallary(gallary: allGalleries[indexPath.section][indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Recently Deleted"
        } else {return nil}
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let gallery = allGalleries[indexPath.section][indexPath.row]
            
            let undelete = UIContextualAction(style: .normal,
                                              title: "Undelete") { (
                                                contextAction : UIContextualAction,
                                                sourceView: UIView,
                                                completionHandler: (Bool) -> Void) in
                                                self.gallaryModel?.requestToUndeleteGallary(gallary: gallery)
            }
            
            undelete.backgroundColor = UIColor.green
            let configs = UISwipeActionsConfiguration(actions: [undelete])
            return configs
        }
        return nil
    }
}



// MARK: Gallary Model delegates
extension GallaryStoreViewController : GalleryListDelegate {
    func recentlyDeletedGalleriesDidChange(recentlyDeleted: galleries) {
        _recentlyDeletedGalleries = recentlyDeleted
    }
    
    func viewableGalleriesDidChange(viewableGalleries: galleries) {
        _galleries = viewableGalleries
    }
    
    
}

// MARK: Cell editing delegates
extension GallaryStoreViewController : UserInputDelegate {
    func userUpdatedTextFieldValue(with resulting: String, sender: GallaryNameTableViewCell) {
        guard let indexPath = self.gallaryTable.indexPath(for: sender) else {return}
        
        gallaryModel?.requestNameUpdate(for: allGalleries[indexPath.section][indexPath.row], with: resulting)
        
        
    }
}

// MARK: Constants
private struct SegueIdentifier {
    static let showGallaryDetail = "showGallaryDetail"
}



