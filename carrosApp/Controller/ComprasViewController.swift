//
//  ComprasViewController.swift
//  carrosApp
//
//  Created by Victor Vieira Veiga on 25/11/19.
//  Copyright © 2019 Victor Veiga. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class ComprasViewController: UIViewController {
    
    
    var carrinho : [NSManagedObject] = []
    var compraTotal: [NSManagedObject] = []
    var carros: [Carro] = []
   
    @IBOutlet weak var labelQuantidade: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    
    
    
    @IBOutlet weak var tbViewCarro: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbViewCarro.delegate = self
        tbViewCarro.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let requisicaoCarro = NSFetchRequest<NSFetchRequestResult>(entityName: "Carrinho")
        

        //carrega tela com as informacoes do carrinho
        do {
            self.carrinho = try  context.fetch(requisicaoCarro) as! [NSManagedObject]
            //context.delete(carrinho[0])
            try context.save()

        } catch  {
            print ("Erro.")
        }
        
        CarregaTotalCarrinho()
        tbViewCarro.reloadData()
        
    }
    
    func CarregaTotalCarrinho () {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
    
        let requisicaoCompra = NSFetchRequest<NSFetchRequestResult>(entityName: "CarrinhoTotal")
        
        do {
             self.compraTotal = try context.fetch(requisicaoCompra) as! [NSManagedObject]
            var precoString: String?
            var vlTotal: String?
            if compraTotal.count > 0 {
                if let total = compraTotal[0].value(forKey: "total") as? Float {
                    precoString = "R$" + String(format: "%.2f", total)//Formata preço
                     
                    labelTotal.text = precoString
                    }
                if let quantidade = compraTotal[0].value(forKey: "quantidade") as? Int {
                    vlTotal = String(quantidade)
                    labelQuantidade.text = vlTotal
                }
            }
            else {
                labelTotal.text = "0"
                labelQuantidade.text = "0"
            }
        } catch  {
            print ("Erro")
        }
        
        
    }
    
    @IBAction func RemoveCarro(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let indice = (sender as AnyObject).tag else {return}
        let carro = self.carrinho[indice]

        removeItemTotal(carro)
        context.delete(carro)
        
        self.carrinho.remove(at: indice)
        self.tbViewCarro.reloadData()
        
        do {
            try context.save()
        } catch let erro {
            print ("Erro ao remover item \(erro)")
        }
    
        CarregaTotalCarrinho()
        tbViewCarro.reloadData()
    }
    
    func removeItemTotal (_ carro:NSManagedObject) {
        var totalValor:Double = 0
        var quantidade : Int = 0
        
 
        

        //pega total e quantidade para poder subtrair
        (totalValor, quantidade) = getTotal()
        
        if totalValor > 0 {

            totalValor = (totalValor - (carro.value(forKey: "preco") as! Double))
            quantidade = quantidade - 1
            
            //remove para depois incluir
            excluiTotal()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            //let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "CarrinhoTotal")
            let carrinhoTotal = NSEntityDescription.insertNewObject(forEntityName: "CarrinhoTotal", into: context)
  
        
            do {
                carrinhoTotal.setValue(totalValor, forKey: "total")
                carrinhoTotal.setValue(quantidade, forKey: "quantidade")
                try context.save()
            } catch  {
                print("Erro ao Atualizar Carrinho.")
            }
        
         }

        
    }
    
    func excluiTotal () {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "CarrinhoTotal")
        
               do {
                   let carrinho = try  context.fetch(requisicao) as! [NSManagedObject]
                
                for car in carrinho {
                     try context.delete(car)
                    try context.save()
                }
                
                  
               } catch let erro {
                   print ("Erro ao remover item \(erro)")
               }
    }
    
    func getTotal () -> (Double, Int) {
        var totalValor:Double = 0
        var quantidade : Int = 0
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let requisicaoCompra = NSFetchRequest<NSFetchRequestResult>(entityName: "CarrinhoTotal")
        
        //carrega tela com as informacoes do carrinho
          do {
              let total = try  context.fetch(requisicaoCompra) as! [NSManagedObject]
            
            if total.count > 0 {
                totalValor = total[0].value(forKey: "total") as! Double
                quantidade = total[0].value(forKey: "quantidade") as! Int
            }

          } catch  {
              print ("Erro.")
          }
               
        return (totalValor,quantidade)
    }
    
    
    @IBAction func finalizarCompra(_ sender: Any) {
                
              let appDelegate = UIApplication.shared.delegate as! AppDelegate
              let context = appDelegate.persistentContainer.viewContext
              let compras = NSEntityDescription.insertNewObject(forEntityName: "Compras", into: context)
        
                for car in self.carrinho {
                    
                        guard let id = car.value(forKey: "id") else {return}
                        guard let marca = car.value(forKey: "marca") else {return}
                        guard let preco = car.value(forKey: "preco") else {return}
                        guard let nome = car.value(forKey: "nome") else {return}
        
                        compras.setValue(id, forKey: "id")
                        compras.setValue(marca, forKey: "marca")
                        compras.setValue(preco, forKey: "preco")
                        compras.setValue(nome, forKey: "nome")
                        
                        do {
                            try context.save()
                        } catch  {
                            print ("Erro ao salvar compra.")
                        }
                
                }
        limpaCarrinho ()
        exibeMensagemAlerta(titulo: "Ok", mensagem: "Compra realizada com sucesso. Parabens.")
        navigationController?.popViewController(animated: true)
        
    }
    

    
    func exibeMensagemAlerta (titulo: String, mensagem:String){
        let myAlert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let oKAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        
        myAlert.addAction(oKAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func limpaCarrinho () {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Carrinho")
        
            
        do {
           let carrinhoCompras  = try context.fetch(requisicao) as! [NSManagedObject]
            
                for car in carrinhoCompras {
                    removeItemTotal(car)
                    context.delete(car)
                    try context.save()
                 }
                self.carrinho.removeAll()
   
        } catch  {
            print ("Erro.")
        }
        
            self.tbViewCarro.reloadData()
            
            do {
                try context.save()
            } catch let erro {
                print ("Erro ao remover item \(erro)")
            }
            excluiTotal()
            CarregaTotalCarrinho()
            tbViewCarro.reloadData()
    }
    
}

extension ComprasViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return carrinho.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  as? CarrinhoTableViewCell {
                  
            cell.carrinho = self.carrinho[indexPath.row]
            cell.btnRemover.tag = indexPath.row
             
            return cell
            }
        return UITableViewCell()

    }
    
    
    
}
