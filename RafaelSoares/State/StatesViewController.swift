//
//  StatesViewController.swift
//  RafaelSoares
//
//  Created by Usuário Convidado on 23/04/18.
//  Copyright © 2018 fiap. All rights reserved.
//

import UIKit
import CoreData

enum DialogType {
    case add
    case edit
}

class StatesViewController: UIViewController {
    
    @IBOutlet weak var tfQuote: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var statesDataSource: [State] = []
    var product: Product!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadStates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tfQuote.text = UserDefaults.standard.string(forKey: "quote")
        tfIOF.text = UserDefaults.standard.string(forKey: "iof")
        
        var fieldsWithProblem: [String] = []
        if let _: Double = Double(tfQuote.text!) {
            // Não faço nada
        } else {
            fieldsWithProblem.append("Cotação do Dólar")
        }
        if let _: Double = Double(tfIOF.text!) {
            // Não faço nada
        } else {
            fieldsWithProblem.append("IOF")
        }
        
        print(fieldsWithProblem)
        
        if !fieldsWithProblem.isEmpty {
            let fields: String = fieldsWithProblem.map({$0}).joined(separator: " e ")
            if fieldsWithProblem.count > 1 {
                showAlert(withMessage: "Os campos: \(fields) possuem valores inválidos. Favor preencher novamente.", withTitle: "Valores inválidos")
            } else {
                showAlert(withMessage: "O campo: \(fields) possuí valor inválido. Favor preencher novamente.", withTitle: "Valor inválido")
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(tfQuote.text!, forKey: "quote")
        UserDefaults.standard.set(tfIOF.text!, forKey: "iof")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - Methods
    func showAlert(withMessage message: String, withTitle title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            statesDataSource = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func showAlert(type: DialogType, state: State?) {
        let title = (type == .add) ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: "\(title) Estado", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome do estado"
            if let name = state?.name {
                textField.text = name
            }
        }
        alert.addTextField { (textField: UITextField) in
            textField.keyboardType = .decimalPad
            textField.placeholder = "Imposto"
            if let stateTax = state?.stateTax {
                textField.text = String(stateTax)
            }
        }
        
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            let state = state ?? State(context: self.context)
            state.name = alert.textFields?.first?.text
            if let stateTaxField = alert.textFields?[1] {
                state.stateTax = stateTaxField.text!.convertToDoubleDecimal
            }
            do {
                try self.context.save()
                self.loadStates()
            } catch {
                print(error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: UIButton) {
        showAlert(type: .add, state: nil)
    }
    

}


// MARK: - UITableViewDelegate
extension StatesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = self.statesDataSource[indexPath.row]
        showAlert(type: .edit, state: state)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let state = self.statesDataSource[indexPath.row]
            self.context.delete(state)
            try! self.context.save()
            self.statesDataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [deleteAction]
    }
}

// MARK: - UITableViewDelegate
extension StatesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statesDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)
        let state = self.statesDataSource[indexPath.row]
        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = "\(state.stateTax)"
        return cell
    }
}
