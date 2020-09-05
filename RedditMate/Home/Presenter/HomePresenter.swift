//
//  HomePresenter.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/5/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation

class HomePresenter {
    
    weak var view: HomeView?
    
    init(view: HomeView) {
        self.view = view
    }
    
    func fetchItems() {
        let items = [
            Item(name: "t2_nfkfh", title: "Some post title", author: "Author", thumbnail: "url", numComments: 123)
        ]
        
        self.view?.showItems(items)
    }
}
