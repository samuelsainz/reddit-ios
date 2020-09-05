//
//  HomeView.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/5/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation

protocol HomeView: class {
    
    /// Show `items` in `HomeView`
    func showItems(_ items: [Item])
}
