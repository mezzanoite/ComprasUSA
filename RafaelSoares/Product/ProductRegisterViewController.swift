//
//  ProductRegisterViewController.swift
//  RafaelSoares
//
//  Created by user138685 on 4/21/18.
//  Copyright © 2018 fiap. All rights reserved.
//

import UIKit
import CoreData

class ProductRegisterViewController: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivPicture: UIImageView!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var swUsedCreditCard: UISwitch!
    
    var product: Product!
    var smallImage: UIImage!
    
    // PickerView que será usado como entrada para o textField de Estado
    var statesPickerView: UIPickerView!
    
    var statesDataSource:[State] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if product != nil {
            tfName.text = product.name
            if let image = product.picture as? UIImage {
                ivPicture.image = image
            }
            tfState.text = product.state?.name
            tfValue.text = String(product.value)
            swUsedCreditCard.isOn = product.usedCreditCard
        }
        
        // Criando o picker view de Estado
        statesPickerView = UIPickerView()
        statesPickerView.backgroundColor = .white
        
        // Definindo os delegates do picker view de Estado
        statesPickerView.delegate = self
        statesPickerView.dataSource = self
        
        // Criando a toolbar que será usada no picker view de Estado
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]
        tfState.inputAccessoryView = toolbar
        
        // Definindo que o input do textField de estado será o nosso picker view de Estado
        tfState.inputView = statesPickerView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadStates()
    }
    
    @objc func cancel() {
        tfState.resignFirstResponder()
    }
    

    @objc func done() {
        tfState.text = statesDataSource[statesPickerView.selectedRow(inComponent: 0)].name
        cancel()
    }
    
    // Fazer o teclado sumir ao tocar fora dele
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK:  Methods
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        //Criando o objeto UIImagePickerController
        let imagePicker = UIImagePickerController()
        
        //Definimos seu sourceType através do parâmetro passado
        imagePicker.sourceType = sourceType
        
        //Definimos a MovieRegisterViewController como sendo a delegate do imagePicker
        imagePicker.delegate = self
        
        //Apresentamos a imagePicker ao usuário
        present(imagePicker, animated: true, completion: nil)
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            statesDataSource = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func showAlert(withMessage message: String, withTitle title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func validateFields() -> String {
        var fieldsRequired: [String] = []
        if tfName == nil || (tfName.text?.isEmpty)! {
            fieldsRequired.append("Nome")
        }
        if ivPicture.image == nil {
            fieldsRequired.append("Imagem")
        } else {
            let defaultImage = UIImage(named: "giftbox")
            if (ivPicture.image == defaultImage) {
                fieldsRequired.append("Imagem")
            }
        }
        if tfState == nil || (tfState.text?.isEmpty)! {
            fieldsRequired.append("Estado")
        }
        if tfValue == nil || (tfValue.text?.isEmpty)! {
            fieldsRequired.append("Valor")
        }
        if !fieldsRequired.isEmpty {
            return fieldsRequired.map({$0}).joined(separator: ", ")
        }
        return ""
    }
    
    @IBAction func addUpdateProduct(_ sender: UIButton) {
        let validationMessage: String = validateFields()
        if  !validationMessage.isEmpty {
            showAlert(withMessage: validationMessage, withTitle: "Os seguintes campos são obrigatórios e não foram preenchidos: ")
        } else {
            if product == nil {
                product = Product(context: context)
            }
            product.name = tfName.text!
            if let myValue: Double = Double(tfValue.text!) {
                product.value = myValue
            } else {
                showAlert(withMessage: "O campo de Valor do Produto possuí um valor inválido. Favor preencher novamente.", withTitle: "Valor inválido")
            }
            if smallImage != nil {
                product.picture = smallImage
            }
            product.usedCreditCard = swUsedCreditCard.isOn
            for state in statesDataSource {
                if (state.name == tfState.text) {
                    product.state = state
                }
            }
            if (product.state == nil) {
                print("Erro de validacao")
            }
            do {
                try context.save()
                self.navigationController?.popViewController(animated: true)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func addPicture(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar imagem do produto", message: "De onde você quer escolher a imagem?", preferredStyle: .actionSheet)
        
        // Verificação se o device possui câmera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension ProductRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        ivPicture.image = smallImage
        dismiss(animated: true, completion: nil)
    }
}

extension ProductRegisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statesDataSource[row].name
    }
    
}

extension ProductRegisterViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statesDataSource.count
    }
    
}
