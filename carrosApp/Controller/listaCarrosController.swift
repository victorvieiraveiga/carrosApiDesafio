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

  
    @IBOutlet var tbViewCarro: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tbViewCarro.delegate = self
        tbViewCarro.dataSource = self
        
//        tbViewCarro.register(UINib(nibName: "CarroTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        //call func api
        getCarros()

//        Alamofire.request(Constantes.URL_API).responseJSON { (response) in
//
//
//             DispatchQueue.main.async {
//                if let responseValue = response.result.value  {
//                        //print (responseValue.description)
//                    self.carros  = responseValue as! [Carro]
//                        //self.carros[0].descricao
//                        self.tbViewCarro.reloadData()
//                    }
//            }
//
//        }
        
        
    }
    
    
    @IBAction func AdicionaNoCarrinho(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let carrinho = NSEntityDescription.insertNewObject(forEntityName: "Carrinho", into: context)
        
        
        
        
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
    
    
    
//    func getCarros(){
//        ApiConfiguration.getCarros { (carros) in
//            self.carros = [carros]
//            print (self.carros)
//            DispatchQueue.main.async {
//                      self.tbViewCarro.reloadData()
//            }
//        }
//
//
//    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return carros.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: CarroTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CarroTableViewCell {
            
            cell.carro = carros[indexPath.row]
            
           
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
