//
//  DetalheCarroViewController.swift
//  carrosApp
//
//  Created by Victor Veiga on 20/11/19.
//  Copyright © 2019 Victor Veiga. All rights reserved.
//

import UIKit
import SDWebImage

class DetalheCarroViewController: UIViewController {
var carros : [Carro] = [Carro]()
    
    @IBOutlet weak var imgCarro: UIImageView!
    
    @IBOutlet weak var nomeCarro: UILabel!
    
    @IBOutlet weak var descricaoCarro: UILabel!
    
    var index: Int = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let carro = carros[index]
        
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
        
        nomeCarro.text = carro.nome
        descricaoCarro.text = carro.descricao
        
        
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
