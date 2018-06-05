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
        print("A")
    }
    private var gallaryModel = GalleriesModel()

    fileprivate var galleries = [GallaryStoreItem]() {didSet {
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source



    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
     
     
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GallaryStoreViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // to implement
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
    func viewableGalleriesDidChange(viewableGalleries: galleries) {
        galleries = viewableGalleries
    }
    
    func recentlyDeletedGalleriesDidChange(recentlyDeleted: galleries) {
        recentlyDeletedGalleries = recentlyDeleted
    }
    
    
}
