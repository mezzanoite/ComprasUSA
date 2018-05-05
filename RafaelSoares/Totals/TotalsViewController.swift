//
//  TotalsViewController.swift
//  RafaelSoares
//
//  Created by Rafael Soares on 01/05/18.
//  Copyright © 2018 fiap. All rights reserved.
//

import UIKit
import CoreData

class TotalsViewController: UIViewController {

    @IBOutlet weak var totalDollars: UILabel!
    @IBOutlet weak var totalReais: UILabel!
    
    var temporaryTotalDollars: Double = 0
    var temporaryTotalReais: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        temporaryTotalDollars = 0
        temporaryTotalReais = 0
        
        let quote: Double = getDollarQuote()
        let iof: Double = convertToTaxRate(getIOF())
        
        let productsDataSource: [Product] = loadProducts()
        for product in productsDataSource {
            temporaryTotalDollars += product.value
            let stateTax: Double = convertToTaxRate((product.state?.stateTax)!)
            if product.usedCreditCard {
                temporaryTotalReais = temporaryTotalReais + (product.value * iof * quote * stateTax)
            } else {
                temporaryTotalReais = temporaryTotalReais + (product.value * quote * stateTax)
            }
        }
        
        totalDollars.text = String(temporaryTotalDollars)
        totalReais.text = String(temporaryTotalReais)
    }
    
    func loadProducts() -> [Product] {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    func getDollarQuote() -> Double {
        return (UserDefaults.standard.string(forKey: "quote")?.convertToDoubleDecimal)!
    }
    
    func getIOF() -> Double {
        return (UserDefaults.standard.string(forKey: "iof")?.convertToDoubleDecimal)!
    }
    
    func convertToTaxRate(_ tax: Double) -> Double{
        return 1 + (tax/100)
    }
    
}
