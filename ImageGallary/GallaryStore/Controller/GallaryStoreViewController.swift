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
        galleries.append(GallaryStoreItem())
        
    }
    private var gallaryModel = GalleriesModel()
    
    fileprivate var galleries = [GallaryStoreItem]() {didSet {
        print(galleries.count)
        self.gallaryTable?.reloadData()
        }
    }
    fileprivate var recentlyDeletedGalleries = [GallaryStoreItem]() {didSet {
        self.gallaryTable?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gallaryTable.delegate = self
        gallaryTable.dataSource = self
        gallaryModel.delegate = self 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GallaryStoreViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// Section 0 is are the galleries
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "GallaryNameCell", for: indexPath) as? GallaryNameTableViewCell {
                guard galleries.indices.contains(indexPath.row) else {return UITableViewCell()}
                cell.textField.text = galleries[indexPath.row].gallaryname ?? ""
                cell.delegate = self
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        /// Return the number of items with > 0
        //let viewable = galleries.count > 0 ? 1 : 0
        //let deleted = recentlyDeletedGalleries.count > 0 ? 1 : 0
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return galleries.count
        case 1:
            return recentlyDeletedGalleries.count
        default:
            return 0
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
        
        switch indexPath.section {
        case 0:
            gallaryModel.requestNameUpdate(for: galleries[indexPath.row], with: resulting)
        case 1:
            gallaryModel.requestNameUpdate(for: recentlyDeletedGalleries[indexPath.row], with: resulting)
        default :
            return
        }
        
    }
    
}





