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
    
    var items: [Item]?
    
    lazy var imageFetcher: ImageFetcher = ImageFetcher()
    
    init(view: HomeView) {
        self.view = view
    }
    
    // MARK: Items management
    
    /// Get the items and update the view
    func fetchItems() {
        ItemsService.fetchIems() { (items, error) in
            guard error == nil else {
                // TODO: Show error view
                return
            }
            
            guard let items = items else {
                return
            }
            
            self.items = items
            self.view?.showItems(items)
        }
    }
    
    /// This method is invoked when an item is dismissed
    /// - Parameter index: Dismissed item index
    func itemDismissed(index: Int) {
        // TODO: validate index
        self.items?.remove(at: index)
        self.view?.showItems(self.items!)
    }
    
    /// This method is invoked when an item is selected
    /// - Parameter index: Selected item index
    func itemSelected(index: Int) {
        // TODO: validate index
        // TODO: navigate
        var item = self.items![index]
        item.wasRead = true
        // TODO update cell
    }
    
    // MARK: Images management
    
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
    
    /// Cancel the image fetch if it's not finished yet
    /// - Parameter token: The unique token that identifies the request to be cancelled
    func cancelItemImageFetch(token: UUID?) {
        guard let token = token else {
            return
        }
        
        self.imageFetcher.cancelLoad(token)
    }
}
