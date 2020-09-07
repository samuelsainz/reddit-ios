//
//  Double+Additions.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/6/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
