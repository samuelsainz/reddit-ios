//
//  ImageFetcher.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/5/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation
import UIKit

/// Image fetcher to manage efficiently the image loaded in a table view
class ImageFetcher {
        
    /// Images already ferched, catched to be used again
    private lazy var fetchedImagesCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = 200
        cache.totalCostLimit = 1024 * 1024 * 200
        return cache
    }()
    
    /// Requests in progress
    private var runningRequests = [UUID: URLSessionDataTask]()
        
    /// Use this method to fech an image form a url
    /// - Parameters:
    ///   - url: The url from which the image is going to be fetched
    ///   - completion: The completion block invoked with the operation result
    /// - Returns: A unique identifier for the task
    func fetchImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
        if let image = fetchedImagesCache.object(forKey: url as AnyObject) as? UIImage {
            completion(.success(image))
            return nil
        }

        let uuid = UUID()

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            defer { self.runningRequests.removeValue(forKey: uuid) }

            if let data = data, let image = UIImage(data: data) {
                self.fetchedImagesCache.setObject(image as AnyObject, forKey: url as AnyObject)
                completion(.success(image))
                return
            }

            guard let error = error else {
                return
            }

            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }

            // the request was cancelled, no need to call the callback
        }
        task.resume()

        runningRequests[uuid] = task
        return uuid
    }
    
    /// This method receives a UUID, uses it to find a running data task and cancels that task.
    /// It also removes the task from the running tasks dictionary, if it exists.
    /// - Parameters:
    ///     - uuid: The unique universal identifier for the request to be cancelled 
    func cancelLoad(_ uuid: UUID) {
      runningRequests[uuid]?.cancel()
      runningRequests.removeValue(forKey: uuid)
    }
}
