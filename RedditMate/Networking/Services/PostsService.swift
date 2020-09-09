//
//  PostsService.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/6/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation

class PostsService {
    
    static func fetchPosts(endpoint: Endpoint, completion: @escaping (APIResponse?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: endpoint.url) { data, response, error in
            // Check if an error occured
            guard error == nil else {
                completion(nil, error)
                return
            }

            // Serialize the data into an object
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data! )
                completion(apiResponse, nil)
            } catch {
                print("Error during JSON serialization: \(error.localizedDescription)")
                debugPrint(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
}
