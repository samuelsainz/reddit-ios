//
//  ItemTableViewCell.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/5/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    static let identifier = "ItemTableViewCell"
    
    var onReuse: () -> Void = {}

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var thumbnailHeightConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        onReuse()
        thumbnailImageView.image = nil
        thumbnailHeightConstraint.constant = 0
    }
        
    func configure(withItem item: Item) {
        self.titleLabel?.text = item.title
        
        if let thumbnail = item.thumbnail {
            let ratio = CGFloat(item.thumbnailWidth) / CGFloat(item.thumbnailHeight)
            let newHeight = self.contentView.frame.size.width / ratio
            thumbnailHeightConstraint.constant = newHeight
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if (selected) {
            contentView.backgroundColor = UIColor.systemGray5
        } else {
            contentView.backgroundColor = UIColor.systemBackground
        }
    }
}
