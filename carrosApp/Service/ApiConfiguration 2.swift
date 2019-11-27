//
//  ApiConfiguration.swift
//  carrosApp
//
//  Created by Victor Veiga on 19/11/19.
//  Copyright © 2019 Victor Veiga. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

 func getCarros(tipoCarro:String, completion:@escaping (([Carro]) -> Void)){
    if let url = URL(string: Constantes.URL_API){
        var request = URLRequest(url: url)
        request.timeoutInterval = 0
        request.setValue("application/gzip", forHTTPHeaderField: "Accept-Encoding")
        Alamofire.request(request).responseData(completionHandler: { (response) in
            do {
                let carroResponse = try JSONDecoder().decode(CarrosResponse.self, from: response.data!)
                completion(carroResponse.carros.carro)
            } catch{
                print("erro na requisição ou no parser")
            }
        })
    }
}
