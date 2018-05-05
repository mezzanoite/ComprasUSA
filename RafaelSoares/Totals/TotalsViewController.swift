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
    
    var fieldsWithProblem: [String] = []

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        temporaryTotalDollars = 0
        temporaryTotalReais = 0
        
        fieldsWithProblem.removeAll()
        
        let quote: Double = getDollarQuote()
        let iof: Double = convertToTaxRate(getIOF())
        
        print("\(quote) | \(iof)")
        
        if !fieldsWithProblem.isEmpty {
            let fields: String = fieldsWithProblem.map({$0}).joined(separator: " e ")
            if fieldsWithProblem.count > 1 {
                showAlert(withMessage: "Os campos: \(fields) possuem valores inválidos. Favor corrigir na tela de ajustes.", withTitle: "Total não pode ser calculado corretamente!")
            } else {
                showAlert(withMessage: "O campo: \(fields) possuí valor inválido. Favor corrigir na tela de ajustes.", withTitle: "Total não pode ser calculado corretamente!")
            }
        }
        
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
    
    func showAlert(withMessage message: String, withTitle title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
        if let quote: Double = Double(UserDefaults.standard.string(forKey: "quote")!) {
            return quote
        } else {
            fieldsWithProblem.append("Cotação do Dólar")
        }
        return 0
    }
    
    func getIOF() -> Double {
        if let iof: Double = Double(UserDefaults.standard.string(forKey: "iof")!) {
            return iof
        } else {
            fieldsWithProblem.append("IOF")
        }
        return 0
    }
    
    func convertToTaxRate(_ tax: Double) -> Double{
        return 1 + (tax/100)
    }
    
}
