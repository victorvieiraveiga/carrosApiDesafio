//
//  ApiCarro.swift
//  carrosApp
//
//  Created by Victor Veiga on 20/11/19.
//  Copyright © 2019 Victor Veiga. All rights reserved.
//

import Foundation
enum CarroErro: Error {
    case noDataAvailable
    case canNoteProcessData
}
//Classe para fazer requisicao da API fornecida pelo Hotel Urbano
class ApiCarro {
    let recursoURL: URL
    init () {
        let  recursoString = Constantes.URL_API
        
        guard let recursoURL = URL(string: recursoString) else {fatalError()}
        
        self.recursoURL = recursoURL
    }
    
      func fetchCarros( sucess: @escaping ([Carro]) -> Void, failure: @escaping (Error) -> Void) {
        let  recursoString = Constantes.URL_API
        
        if let url = URL(string: recursoString){
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request, completionHandler : { (data, response, error) in
                if let erro = error {
                    DispatchQueue.main.async {
                        failure(erro)
                    }
                }else{
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let carroResponse = try decoder.decode([Carro].self, from: data)
                            //let carroResponse = try JSONDecoder().decode(Carro.self, from: data)
                            DispatchQueue.main.async {
                                sucess(carroResponse)
                            }
                        }catch {
                            DispatchQueue.main.async {
                                failure(error)
                            }
                        }
                    }
                }
            }).resume()
        }else{
            print("error url")
        }
    }
    
}
