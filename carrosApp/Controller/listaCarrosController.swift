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
    var fetchingMore = false
    var  i: Int = 0

    @IBOutlet weak var btnCarrinho: UIBarButtonItem!
    @IBOutlet var tbViewCarro: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tbViewCarro.delegate = self
        tbViewCarro.dataSource = self
        
        let loadingNib = UINib(nibName: "LoadingCell", bundle: nil)
        tableView.register(loadingNib, forCellReuseIdentifier: "loadingCell")
        
        
        if verificaCarrinho() == 0 {
            btnCarrinho.isEnabled = false
        }
        else {
            btnCarrinho.isEnabled = true
        }
        
        getCarros()
       //excluiTotal()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if verificaCarrinho() == 0 {
            btnCarrinho.isEnabled = false
        }
        else {
            btnCarrinho.isEnabled = true
        }
    }
    

    @IBAction func AddNoCarrinho(_ sender: Any) {
       
        guard let indice = (sender as AnyObject).tag else {return}
        var total: Double = 0
        var quantidade: Int = 0
      
        //declara variaveis CoreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let carrinho = NSEntityDescription.insertNewObject(forEntityName: "Carrinho", into: context)
        

        
        //Setando valores no objeto Coredata
        carrinho.setValue(carros[indice].id, forKey: "id")
        carrinho.setValue(carros[indice].nome, forKey: "nome")
        carrinho.setValue(carros[indice].preco, forKey: "preco")
        carrinho.setValue(carros[indice].imagem, forKey: "imagem")
        carrinho.setValue(carros[indice].marca, forKey: "marca")
        carrinho.setValue(carros[indice].descricao, forKey: "descricao")
        carrinho.setValue(1, forKey: "quantidade")
        
        //Realiza Totalização
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
    
    func verificaCarrinho () -> Int {
        //verifica se existe itens no carrinho para habilitar o botão
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let requisicaoCarro = NSFetchRequest<NSFetchRequestResult>(entityName: "Carrinho")
        
              //carrega tela com as informacoes do carrinho
          do {
              let carrinho = try  context.fetch(requisicaoCarro) as! [NSManagedObject]
            return carrinho.count

          } catch  {
              print ("Erro.")
             return 0
          }
        
       
    }
    
    
    func AddTotal (_ valor: Double, _ quantidade:Int) {
        //Esta função soma os valores dos carros adicionados no carrinho
        //e incremente sua quantidade.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let carrinhoTotal = NSEntityDescription.insertNewObject(forEntityName: "CarrinhoTotal", into: context)
        

               
            do {

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
            //self.tbViewCarro.reloadData()
            
        }) { (error) in
            self.isError = true
            print(error)
        }
   
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        if section == 0 {
            return carros.count
        } else if section == 1 && fetchingMore {
            return 1
        }
        return 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
           return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        
            guard let cell: CarroTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CarroTableViewCell else {return  UITableViewCell()}
            
            cell.carro = carros[indexPath.row]
            cell.btnCarrinho.tag = indexPath.row
           
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as? LoadingCell else {return  UITableViewCell()}
            
            cell.spinner.startAnimating()
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        
        if offsetY > contentHeight - scrollView.frame.height * 4 {
            if !fetchingMore {
                beginBatchFetch()
            }
            
        }
    }
    
    
    func beginBatchFetch() {
        fetchingMore = true
        print("beginBatchFetch!")
        self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
     
        self.carros.append(self.carros[self.i])
        self.fetchingMore = false
        self.tableView.reloadData()
        self.i = self.i + 1
            
        })
    }
    


}
