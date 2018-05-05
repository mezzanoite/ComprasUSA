//
//  ProductsTableViewController.swift
//  RafaelSoares
//
//  Created by user138685 on 4/17/18.
//  Copyright © 2018 fiap. All rights reserved.
//

import UIKit
import CoreData

class ProductsTableViewController: UITableViewController {
    
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
    var fetchedResultController: NSFetchedResultsController<Product>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 106
        label.text = "Sua lista está vazia!"
        label.textAlignment = .center
        label.textColor = .black
        
        loadProducts()
    }
    
    func loadProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "cellDetail") {
            if let vc = segue.destination as? ProductRegisterViewController {
                vc.product = fetchedResultController.object(at: tableView.indexPathForSelectedRow!)
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultController.fetchedObjects?.count {
            tableView.backgroundView = (count == 0) ? label : nil
            return count
        } else {
            tableView.backgroundView = label
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell
        let product = fetchedResultController.object(at: indexPath)
        cell.lbValue.text = "\(product.value)"
        cell.lbName.text = product.name
        if let image = product.picture as? UIImage {
            cell.ivPicture.image = image
        } else {
            cell.ivPicture.image = nil
        }
        return cell
    }

}

extension ProductsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
