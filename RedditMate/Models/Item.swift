//
//  Item.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/5/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation

struct Item: Codable, Hashable {
    let identifier = UUID()
    let name: String
    let title: String
    let author: String
    let date = Date()
    let thumbnail: String?
    let numComments: Int
    let wasRead: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case name, title, author, thumbnail
        case numComments = "num_comments"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
