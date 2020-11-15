//
//  ProductTableViewController.swift
//  shopWhat
//
//  Created by nju on 2020/11/11.
//  Copyright © 2020 youngstudent2. All rights reserved.
//

import UIKit
import os.log
class ProductTableViewController: UITableViewController {
    var products = [Product]()
    
    private func loadSampleProducts() {
        let photo1 = UIImage(named: "product1")
        let photo2 = UIImage(named: "product2")
        let photo3 = UIImage(named: "product3")
        guard let product1 = Product(name: "Caprese Salad", photo: photo1, rating: 3,comment: "zhen bu chuo") else {
            fatalError("Unable to instantiate product1")
        }
        guard let product2 = Product(name: "Chicken and Potatoes", photo: photo2, rating: 3,comment: "zhen bu chuo") else {
            fatalError("Unable to instantiate product2")
        }
        guard let product3 = Product(name: "Pasta with Meatballs", photo: photo3, rating: 3,comment: "zhen bu chuo") else {
            fatalError("Unable to instantiate product3")
        }
        products += [product1,product2,product3]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        
        if let savedProducts = loadProducts() {
            products += savedProducts
        }
        else {
            loadSampleProducts()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ProductTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProductTableViewCell else {
            fatalError("The dequeued cell is not an instance of ProductTableViewCell")
        }
        let product = products[indexPath.row]
        cell.nameLabel.text = product.name
        cell.photoImageView.image = product.photo
        cell.ratingControl.rating = product.rating
        return cell
    }
    
    @IBAction func unwindToProductList(sender:UIStoryboardSegue){
        if let sourceViewController = sender.source as? ProductViewController, let product = sourceViewController.product {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                products[selectedIndexPath.row] = product
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                let newIndexPath = IndexPath(row: products.count, section: 0)
                products.append(product)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
            saveProducts()
        }
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            products.remove(at: indexPath.row)
            saveProducts()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new product", log: OSLog.default, type:.debug)
        case "ShowDetail":
            guard let productDetailViewController = segue.destination as? ProductViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedProductCell = sender as? ProductTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "")")
            }
             
            guard let indexPath = tableView.indexPath(for: selectedProductCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
             
            let selectedProduct = products[indexPath.row]
            productDetailViewController.product = selectedProduct
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "")")
        }
    }
    
    private func saveProducts(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(products, toFile: Product.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Products successfully saved.",log:OSLog.default,type:.debug)
        }
        else{
            os_log("Failed to save meals...", log:OSLog.default,type:.error)
        }
    }
    
    private func loadProducts() -> [Product]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile:Product.ArchiveURL.path) as? [Product]
        
    }
}
