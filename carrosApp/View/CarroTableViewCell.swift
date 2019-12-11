//
//  CarroTableViewCell.swift
//  carrosApp
//
//  Created by Victor Veiga on 19/11/19.
//  Copyright © 2019 Victor Veiga. All rights reserved.
//

import UIKit
import SDWebImage


class CarroTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCarro: UIImageView!
    @IBOutlet weak var txtNomeCarro: UILabel!
    @IBOutlet weak var txtPreco: UILabel!
    @IBOutlet weak var btnCarrinho: UIButton!
    
    
    
    var carro:Carro!{
        didSet{
            setCarro()
        }
    }
    
    
   func setCarro(){
    
        txtNomeCarro.text = carro.nome
    
        var precoString: String?
        if let preco = carro.preco {
            precoString = "R$" + String(format: "%.2f", preco)//Formata preço
            txtPreco.text = precoString
        }
    
        if let urlImagem = carro.imagem {
            let url = URL(string: urlImagem)
            DispatchQueue.main.async {
                self.imgCarro.sd_setImage(with: url) { (image, error, cache, url) in
                
                    if error != nil {
                            self.imgCarro.image = UIImage(named: "imagem_padrao.png")
                    }else {
                        print ("foto exibida")
                    }
            }
        }
    }
    }

}



