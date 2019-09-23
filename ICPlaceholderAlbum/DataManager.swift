//
//  DataManager.swift
//  ICPlaceholderAlbum
//
//  Created by 胡仁恩 on 2019/9/23.
//  Copyright © 2019 alexHu. All rights reserved.
//

import Foundation

class DataManager {
    let apiUrlString = "https://jsonplaceholder.typicode.com/photos"
    static let shared  = DataManager()
}

extension DataManager {
    
    func getAlbumJSON(_ completion: @escaping ([PhotoContent]) -> Void) {
        guard let url: URL = URL(string: apiUrlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (jsonData, response, error) in
            let decoder = JSONDecoder()
            if let jsonData = jsonData, let apiResponse = try? decoder.decode([PhotoContent].self, from: jsonData) {
                DispatchQueue.main.sync {
                    completion(apiResponse)
                }
            } else {
                assertionFailure("API fetching failed.")
                
            }
        }
        task.resume()
    }
    
    func fetchImage(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTask {
        
        let session: URLSession = URLSession(configuration: .default)
        return session.dataTask(with: url, completionHandler: completionHandler)
    }
    
    
}

