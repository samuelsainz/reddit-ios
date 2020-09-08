//
//  APIResponse.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/6/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//
import Foundation

// MARK: Response
struct APIResponse: Codable {
    let kind: Kind
    let data: ResponseData
}

// MARK: ResponseData
struct ResponseData: Codable {
    let modhash: String
    let dist: Int
    let children: [Child]
    let after: String?
    let before: String?
}

// MARK: Child
struct Child: Codable {
    let kind: Kind
    let data: Post
}

/// The kind is a String identifier that denotes the object's type
enum Kind: String, Codable {
    case listing = "Listing"
    case comment = "t1"
    case account = "t2"
    case link = "t3"
    case message = "t4"
    case subreddit = "t5"
    case award = "t6"
    case more = "more"
}
