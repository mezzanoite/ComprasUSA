//
//  ProductRegisterViewController.swift
//  RafaelSoares
//
//  Created by user138685 on 4/21/18.
//  Copyright © 2018 fiap. All rights reserved.
//

import UIKit

class ProductRegisterViewController: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivPicture: UIImageView!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfValue: UITextField!
    
    var product: Product!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func addUpdateProduct(_ sender: UIButton) {
        if product == nil {
            product = Product(context: context)
        }
        product.name = tfName.text!
        product.value = Double(tfValue.text!)!
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
