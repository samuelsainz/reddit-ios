//
//  ItemsService.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/6/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation
import Combine

class ItemsService {
 
    static func fetchIems(completion: @escaping ([Item]?, Error?) -> Void) {
        let url = URL(string: "https://www.reddit.com/best/.json?limit=30")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check if an error occured
            guard error == nil else {
                completion(nil, error)
                return
            }

            // Serialize the data into an object
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data! )
                let items = apiResponse.data.children.map { $0.data }
                completion(items, nil)
            } catch {
                print("Error during JSON serialization: \(error.localizedDescription)")
                debugPrint(error)
                completion(nil, error)
            }
        }
        task.resume()
    }

}
