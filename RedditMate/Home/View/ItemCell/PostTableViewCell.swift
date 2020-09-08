//
//  PostTableViewCell.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/5/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    static let identifier = "PostTableViewCell"
    
    var onReuse: () -> Void = {}
    var onDismiss: () -> Void = {}

    @IBOutlet weak var timeSinceCreatedLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var numCommentsLabel: UILabel!
    @IBOutlet weak var numUpsLabel: UILabel!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var thumbnailHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var unreadIndicatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let side = self.unreadIndicatorView.frame.size.width
        self.unreadIndicatorView.layer.cornerRadius = side / 2
        
        self.unreadIndicatorView.layer.shadowColor = UIColor.systemBlue.cgColor
        self.unreadIndicatorView.layer.shadowOpacity = 0.8
        self.unreadIndicatorView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.unreadIndicatorView.layer.shadowRadius = 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        onReuse()
        thumbnailImageView.image = nil
        thumbnailHeightConstraint.constant = 0
    }
        
    func configure(withPost post: Post) {
        self.titleLabel?.text = post.title
        self.authorLabel?.text = post.authorUserName
        self.timeSinceCreatedLabel.text = post.dateString
        self.numUpsLabel.text = post.numUpsString
        self.numCommentsLabel.text = post.numCommentsString
        
        if post.thumbnail != nil, let width = post.thumbnailWidth, let height = post.thumbnailHeight {
            let ratio = CGFloat(width) / CGFloat(height)
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
    
    @IBAction func onDismissTapped(_ sender: Any) {
        onDismiss()
    }
}
