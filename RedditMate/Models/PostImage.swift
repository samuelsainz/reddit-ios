//
//  PostImage.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/8/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation

struct PostImages: Codable {
    let images: [PostImage]
    
    var sourceImage: ImageData? {
        return images.first?.source
    }
}

struct PostImage: Codable {
    let source: ImageData
}

struct ImageData: Codable {
    let url: String
    let width: Float
    let height: Float

    var decodedUrl: String? {
        return url.htmlAttributedString?.string
    }
}
