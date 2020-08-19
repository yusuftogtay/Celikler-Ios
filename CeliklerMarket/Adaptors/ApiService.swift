//
//  Apis.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 3.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import Foundation

class ApiService   {
    static func getPostString(params:[String: Any]) -> String
    {
        var data = [String]()
            for (key, value) in params
            {
                data.append(key + "=\(value)")
            }
        return data.map { String($0) }.joined(separator: "&")
    }

    static func callPost(url:URL, params:[String: Any], finish: @escaping ((message:String, data:Data?)) -> Void)
    {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let postString = self.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)

        var result:(message:String, data:Data?) = (message: "Fail", data: nil)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            if(error != nil)
            {
                result.message = "Fail Error not null : \(error.debugDescription)"
            }
            else
            {
                result.message = "Success"
                result.data = data
            }
            finish(result)
        }
        task.resume()
    }
    
    static func callGet(url: URL, finish: @escaping ((message:String, data:Data?)) -> Void) {
        let request = URLRequest(url: url)
        var result:(message:String, data:Data?) = (message: "Fail", data: nil)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            if(error != nil)
            {
                result.message = "Fail Error not null : \(error.debugDescription)"
            }
            else
            {
                result.message = "Success"
                result.data = data
            }

            finish(result)
        }
        task.resume()
    }
}
