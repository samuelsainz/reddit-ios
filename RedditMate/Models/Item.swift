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
    let ups: Int
    let thumbnail: String?
    let thumbnailWidth: Int?
    let thumbnailHeight: Int?
    let created: Double
    let numComments: Int
    var wasRead: Bool = false
    
    func dateString() -> String {
        return Date(timeIntervalSince1970: created).timeAgoString()
    }
    
    func authorUserName() -> String {
        return "u/" + author
    }
    
    func numCommentsText() -> String {
        if (numComments < 1000) {
            return String(numComments)
        } else {
            return "\((Double(numComments) / 1000.0).rounded(toPlaces: 1))K"
        }
    }
    
    func numUpsText() -> String {
        if (ups < 1000) {
            return String(ups)
        } else {
            return "\((Double(ups) / 1000.0).rounded(toPlaces: 1))K"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, title, author, ups, thumbnail
        case thumbnailWidth = "thumbnail_width"
        case thumbnailHeight = "thumbnail_height"
        case created = "created_utc"
        case numComments = "num_comments"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
