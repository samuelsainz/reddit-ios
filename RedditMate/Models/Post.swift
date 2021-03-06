//
//  Post.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/5/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation
import UIKit

struct Post: Codable, Hashable {
    let identifier = UUID()
    let name: String
    let title: String
    let author: String
    let ups: Int
    let subreddit: String
    let thumbnail: String?
    let thumbnailWidth: Int?
    let thumbnailHeight: Int?
    let created: Double
    let numComments: Int
    var wasRead: Bool = false
    let images: PostImages?
    
    /// Returns date with format 'x time ago'
    var dateString: String {
        return Date(timeIntervalSince1970: created).timeAgoString()
    }
    
    /// Returns the username with the Reddit's user prefix 'u/'
    var authorString: String {
        return "by u/" + author
    }
    
    var subredditString: String {
        return "r/" + subreddit
    }
    
    /// Returns a string with the number of comments in Ks
    var numCommentsString: String {
        if (numComments < 1000) {
            return String(numComments)
        } else {
            return "\((Double(numComments) / 1000.0).rounded(toPlaces: 1))K"
        }
    }
    
    /// Returns a string with the number of upvotes in Ks
    var numUpsString: String {
        if (ups < 1000) {
            return String(ups)
        } else {
            return "\((Double(ups) / 1000.0).rounded(toPlaces: 1))K"
        }
    }
    
    var thumbnailLink: String? {
        // cases where thumbnail it is not available
        // API doc: https://github.com/reddit-archive/reddit/wiki/JSON
        if thumbnail != "self", thumbnail != "image",
            thumbnail != "default"  {
            return thumbnail
        }
        return nil
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, title, author, ups, subreddit, thumbnail
        case thumbnailWidth = "thumbnail_width"
        case thumbnailHeight = "thumbnail_height"
        case created = "created_utc"
        case numComments = "num_comments"
        case images = "preview"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(wasRead)
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.identifier == rhs.identifier
            && lhs.wasRead == rhs.wasRead
    }
}
