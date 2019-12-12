//
//  ItensCompradosController.swift
//  carrosApp
//
//  Created by Victor Vieira Veiga on 11/12/19.
//  Copyright © 2019 Victor Veiga. All rights reserved.
//

import UIKit
import CoreData

class ItensCompradosController: UITableViewController {

    var itensCompras : [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let requisicaoCompras = NSFetchRequest<NSFetchRequestResult>(entityName: "Compras")
        

        //carrega tela com as informacoes do carrinho
        do {
            self.itensCompras = try  context.fetch(requisicaoCompras) as! [NSManagedObject]

        } catch  {
            print ("Erro.")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itensCompras.count
       }
       
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//             if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  {
//
//                let compra = self.itensCompras[indexPath.row]
//                cell.textLabel?.text = compra.value(forKey: "marca") as! String
//
//                var precoString: String?
//
//                if let preco = compra.value(forKey: "preco") as?  Double {
//                    precoString = "R$" + String(format: "%.2f", preco)//Formata preço
//                    cell.detailTextLabel?.text = precoString
//                }
//
//               return cell
//               }
//           return UITableViewCell()
//
//       }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let celula = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) {
//
//        }
        return UITableViewCell()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
