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
    var smallImage: UIImage!
    
    var formatter = NumberFormatter()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if product != nil {
            if let image = product.picture as? UIImage {
                ivPicture.image = image
            }
        }
    }
    
    // Fazer o teclado sumir ao tocar fora dele
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func addUpdateProduct(_ sender: UIButton) {
        if product == nil {
            product = Product(context: context)
        }
        product.name = tfName.text!
        
        guard let my_value = formatter.number(from: tfValue.text!)?.doubleValue else {return} // para usar na conversao de double depois
        
        product.value = Double(tfValue.text!)!
        if smallImage != nil {
            product.picture = smallImage
        }
        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func addPicture(_ sender: UIButton) {
        //Criando o alerta que será apresentado ao usuário
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster?", preferredStyle: .actionSheet)
        
        //Verificamos se o device possui câmera. Se sim, adicionamos a devida UIAlertAction
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        //As UIAlertActions de Biblioteca de fotos e Álbum de fotos também são criadas e adicionadas
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
    
    
}

// MARK: - UIImagePickerControllerDelegate
extension ProductRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        //Iremos usar o código abaixo para criar uma versão reduzida da imagem escolhida pelo usuário
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        
        //Atribuímos a versão reduzida da imagem à variável smallImage
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivPicture.image = smallImage //Atribuindo a imagem à ivPoster
        
        //Aqui efetuamos o dismiss na UIImagePickerController, para retornar à tela anterior
        dismiss(animated: true, completion: nil)
    }
}
