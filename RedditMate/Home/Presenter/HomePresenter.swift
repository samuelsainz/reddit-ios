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
        let items = [
            Item(name: "t3_jh8ef8e", title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.", author: "Rekrabsrm", created: 1599285706.0, ups: 232, thumbnail: "https://a.thumbs.redditmedia.com/p22H5tZXMfSVmgbPyNbtkZuAD5FQCjqrZQACYRYeyZ4.jpg", thumbnailWidth: 140, thumbnailHeight: 93, numComments: 123),
            Item(name: "t3_jh8ef8e", title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.", author: "Rekrabsrm", created: 1599285706.0, ups: 232, thumbnail: "https://a.thumbs.redditmedia.com/p22H5tZXMfSVmgbPyNbtkZuAD5FQCjqrZQACYRYeyZ4.jpg", thumbnailWidth: 140, thumbnailHeight: 93, numComments: 123),
            Item(name: "t3_jh8ef8e", title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.", author: "Rekrabsrm", created: 1599285706.0, ups: 232, thumbnail: "https://a.thumbs.redditmedia.com/p22H5tZXMfSVmgbPyNbtkZuAD5FQCjqrZQACYRYeyZ4.jpg", thumbnailWidth: 140, thumbnailHeight: 93, numComments: 123),
        ]
        
        self.view?.showItems(items)
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
            print("Error when fetching image: " + error.localizedDescription)
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
