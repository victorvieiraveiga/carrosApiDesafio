//
//  ComprasViewController.swift
//  carrosApp
//
//  Created by Victor Vieira Veiga on 25/11/19.
//  Copyright © 2019 Victor Veiga. All rights reserved.
//

import UIKit
import CoreData

class ComprasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var carros : [Carro] = [Carro]()

    @IBOutlet weak var tbViewCarro: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbViewCarro.register(UINib(nibName: "CarroTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        carros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  as? CarroTableViewCell {
            
            cell.carro = carros[indexPath.row]
            return cell
        }

        return UITableViewCell()
        
    }

}
