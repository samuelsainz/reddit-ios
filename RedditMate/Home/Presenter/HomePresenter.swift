//
//  HomePresenter.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/5/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation
import UIKit

class HomePresenter {
    
    weak var view: HomeView?
    
    lazy var imageFetcher: ImageFetcher = ImageFetcher()
    
    init(view: HomeView) {
        self.view = view
    }
    
    func fetchItems() {
        ItemsService.fetchIems() { (items, error) in
            guard error == nil else {
                // TODO: Show error view
                return
            }
            
            guard let items = items else {
                return
            }
            
            self.view?.showItems(items)
        }
    }
    
    /// Fetch an item's image and return a identifier for that transaction
    /// Cancel this request using the returned token when cell is reused
    func fetchItemImage(urlString: String, completion: @escaping (UIImage) -> Void) -> UUID? {
        guard let thumbnailURL = URL(string: urlString) else {
            return nil
        }
        
        return self.imageFetcher.fetchImage(thumbnailURL) { result in
          do {
            let image = try result.get()
            completion(image)
          } catch {
            print("Error when fetching image: " + thumbnailURL.absoluteString + error.localizedDescription)
          }
        }
    }
    
    func cancelItemImageFetch(token: UUID?) {
        guard let token = token else {
            return
        }
        
        self.imageFetcher.cancelLoad(token)
    }
}
