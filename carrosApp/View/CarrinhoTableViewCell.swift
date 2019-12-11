//
//  CarrinhoTableViewCell.swift
//  carrosApp
//
//  Created by Victor Vieira Veiga on 30/11/19.
//  Copyright © 2019 Victor Veiga. All rights reserved.
//

import UIKit
import CoreData


class CarrinhoTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCarro: UIImageView!
    @IBOutlet weak var txtNomeCarro: UILabel!
    @IBOutlet weak var txtPreco: UILabel!
    @IBOutlet weak var btnRemover: UIButton!
    
    var carrinho: NSManagedObject! {
        didSet{
            setCarrinho()
        }
    }
    
    func setCarrinho(){
        
         //nome do carro
        if let nome = carrinho.value(forKey: "nome") {
            txtNomeCarro.text = nome as? String
        }
       
     
        //preço do carro
         var precoString: String?
        if let preco = carrinho.value(forKey: "preco") as? Float {
             precoString = "R$" + String(format: "%.2f", preco)//Formata preço
             txtPreco.text = precoString
         } // fim preço

         //foto do carro
        if let urlImagem = carrinho.value(forKey: "imagem") {
            let url = URL(string: urlImagem as! String)
             DispatchQueue.main.async {
                 self.imgCarro.sd_setImage(with: url) { (image, error, cache, url) in
                 
                     if error != nil {
                             self.imgCarro.image = UIImage(named: "imagem_padrao.png")
                     }else {
                         print ("foto exibida")
                     }
                }
            }
        }//fim foto do caaro
     }

}
