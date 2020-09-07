//
//  Date+Additions.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/6/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation

extension Date {
    func timeAgoString() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
