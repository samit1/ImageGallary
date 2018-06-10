//
//  GallaryStoreTableViewController.swift
//  ImageGallary
//
//  Created by Sami Taha on 6/5/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import UIKit

class GallaryStoreViewController: UIViewController {
    
    @IBOutlet weak var gallaryTable: UITableView!
    @IBAction func addGallaryTap(_ sender: UIBarButtonItem) {
        gallaryModel.addGalary()
    }
    private var gallaryModel = GalleriesModel()
    
    fileprivate var galleries = [ImageGallary]() {didSet {
        
        self.gallaryTable?.reloadData()
        }
    }
    fileprivate var recentlyDeletedGalleries = [ImageGallary]() {didSet {
        if recentlyDeletedGalleries.count == 0 && galleries.count == 0 {gallaryModel.addGalary()}
        self.gallaryTable?.reloadData()
        }
    }
    
    fileprivate var allGalleries : [[ImageGallary]] {
        return [galleries, recentlyDeletedGalleries]
    }
    
    private var lastSelectedPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gallaryTable.delegate = self
        gallaryTable.dataSource = self
        gallaryModel.delegate = self
        setupTable()
    }
    private func setupTable() {
        gallaryModel.requestViewableGalleries()
        gallaryModel.requestRecentlyDeletedGallries()
    }
    
    @IBAction func wasDoubleTapped(_ sender: UITapGestureRecognizer) {
        if let cellTapped  = gallaryTable.indexPathForSelectedRow {
            let cell = gallaryTable.cellForRow(at: cellTapped)
            if let gallaryCell = cell as? GallaryNameTableViewCell {
                gallaryCell.isEditing = true
            }
        }
    }
    
}

extension GallaryStoreViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GallaryNameCell", for: indexPath)
        if let galleryCell = cell as? GallaryNameTableViewCell {
            galleryCell.textField.text = allGalleries[indexPath.section][indexPath.row].galleryName
            galleryCell.delegate = self
            galleryCell.isEditing = false
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
        //        performSegue(withIdentifier: "showGallaryDetail", sender: cell)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            gallaryModel.requestToDeleteGallary(gallary: allGalleries[indexPath.section][indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Recently Deleted"
        } else {return nil}
    }
    
    // MARK: Segues
    
    // #TODO : Add check for sender
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? GallaryNameTableViewCell else {return}
        print("Hello")
        
        if let cellSent = gallaryTable.indexPath(for: sender), cellSent.section == 0 {
            
            if let identifier = segue.identifier {
                if identifier == "showGallaryDetail" {
                    if let destinationVC = segue.destination.contents as? ImageGallaryViewController {
                        destinationVC.imageData = allGalleries[cellSent.section][cellSent.row]
                        destinationVC.delegate = self 
                    }
                }
            }
        }
    }
}

extension GallaryStoreViewController : GalleryListDelegate {
    func recentlyDeletedGalleriesDidChange(recentlyDeleted: galleries) {
        recentlyDeletedGalleries = recentlyDeleted
    }
    
    func viewableGalleriesDidChange(viewableGalleries: galleries) {
        galleries = viewableGalleries
    }
    
    
}

extension GallaryStoreViewController : UserInputDelegate {
    func userUpdatedTextFieldValue(with resulting: String, sender: GallaryNameTableViewCell) {
        guard let indexPath = self.gallaryTable.indexPath(for: sender) else {return}
        
        gallaryModel.requestNameUpdate(for: allGalleries[indexPath.section][indexPath.row], with: resulting)
        
        
    }
}

extension GallaryStoreViewController : ImageDetailDataDelegate {
    func imageDetailWillDisappear(imageData: ImageGallary) {
        // gallaryModel.requestGallaryContentsUpdate(for: imageData)
        
    }
    
    
}




