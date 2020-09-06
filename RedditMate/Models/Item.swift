//
//  Item.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/5/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation
import UIKit

struct Item: Codable, Hashable {
    let identifier = UUID()
    let name: String
    let title: String
    let author: String
    let created: Double
    let ups: Int
    let thumbnail: String?
    let thumbnailWidth: Int
    let thumbnailHeight: Int
    let numComments: Int
    var wasRead: Bool = false
    
    func dateString() -> String {
        return Date(timeIntervalSince1970: created).description
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, title, author, created, ups, thumbnail
        case thumbnailWidth = "thumbnail_width"
        case thumbnailHeight = "thumbnail_height"
        case numComments = "num_comments"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
