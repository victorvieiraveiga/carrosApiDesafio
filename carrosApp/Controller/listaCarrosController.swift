//
//  listaCarrosController.swift
//  carrosApp
//
//  Created by Victor Veiga on 19/11/19.
//  Copyright © 2019 Victor Veiga. All rights reserved.
//

import UIKit
import CoreData


class listaCarrosController: UITableViewController {
    
    var carros : [Carro] = [Carro]()
     var isError:Bool = false
    var index: Int = 0

    @IBOutlet weak var btnCarrinho: UIBarButtonItem!
    @IBOutlet var tbViewCarro: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tbViewCarro.delegate = self
        tbViewCarro.dataSource = self
        
        getCarros()
       //excluiTotal()

    }
    

    @IBAction func AddNoCarrinho(_ sender: Any) {
       
        guard let indice = (sender as AnyObject).tag else {return}
        var total: Double = 0
        var quantidade: Int = 0
      
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let carrinho = NSEntityDescription.insertNewObject(forEntityName: "Carrinho", into: context)
        

        
        
        carrinho.setValue(carros[indice].id, forKey: "id")
        carrinho.setValue(carros[indice].nome, forKey: "nome")
        carrinho.setValue(carros[indice].preco, forKey: "preco")
        carrinho.setValue(carros[indice].imagem, forKey: "imagem")
        carrinho.setValue(carros[indice].marca, forKey: "marca")
        carrinho.setValue(carros[indice].descricao, forKey: "descricao")
        carrinho.setValue(1, forKey: "quantidade")
        
        //Pega valor total das compras para somar
        (total,quantidade) = getTotal()
        total = (total + carros[indice].preco! as Double)
        
        // primeiro realiza a exclusao do total
        excluiTotal()
        
        do {
            try context.save()
        } catch  {
            print ("Erro ao salvar dados")
        }
        
        
        if let valor = total as? Double{
                AddTotal(valor,quantidade)
        }
        
        tbViewCarro.reloadData()
        
    }
    
    func AddTotal (_ valor: Double, _ quantidade:Int) {
        
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let carrinhoTotal = NSEntityDescription.insertNewObject(forEntityName: "CarrinhoTotal", into: context)
        
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "CarrinhoTotal")
               
            do {
                //let carrinho = try  context.fetch(requisicao) as! [NSManagedObject]
                //let quantidade = carrinho[0].value(forKey: "quantidade") as! Int
                //let total = carrinho[0].value(forKey: "total") as! Double
                
                carrinhoTotal.setValue(quantidade + 1, forKey: "quantidade")
                carrinhoTotal.setValue( valor, forKey: "total")

                try context.save()
                
               } catch  {
                   print ("Erro.")
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
    

    func getCarros(){
        
        let car = ApiCarro()
        
        car.fetchCarros(sucess: { (cars) in
            //var carros = [Carro] ()
            self.isError = false
            
            self.carros = cars
            self.tableView.reloadData()
            self.tbViewCarro.reloadData()
            
        }) { (error) in
            self.isError = true
            print(error)
        }
   
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return carros.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: CarroTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CarroTableViewCell {
            
            cell.carro = carros[indexPath.row]
            cell.btnCarrinho.tag = indexPath.row
           
            return cell
        }

        // Configure the cell...

        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.index = indexPath.row
        self.carros[self.index] = carros[indexPath.row]
        self.performSegue(withIdentifier: "segueDetalhe", sender: nil)
        
        
     //DetalheView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetalhe" {
            let viewDetalhe = segue.destination as! DetalheCarroViewController
            viewDetalhe.index = self.index
            viewDetalhe.carros = self.carros
        }
    }

}
