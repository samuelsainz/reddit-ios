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
    @IBOutlet weak var unreadIndicatorWidth: NSLayoutConstraint!
    @IBOutlet weak var unreadIndicatorTrailing: NSLayoutConstraint!
    
    let unreadIndicatorSideSize: CGFloat = 8
    let unreadIndicatorRightMargin: CGFloat = 8
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.unreadIndicatorView.layer.cornerRadius = unreadIndicatorSideSize / 2
        
        self.unreadIndicatorView.layer.shadowColor = UIColor.systemBlue.cgColor
        self.unreadIndicatorView.layer.shadowOpacity = 0.8
        self.unreadIndicatorView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.unreadIndicatorView.layer.shadowRadius = 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        onReuse()
        self.thumbnailImageView.image = nil
        self.thumbnailHeightConstraint.constant = 0
    }
        
    func configure(withPost post: Post) {
        self.titleLabel?.text = post.title
        self.authorLabel?.text = post.authorString
        self.timeSinceCreatedLabel.text = post.dateString
        self.numUpsLabel.text = post.numUpsString
        self.numCommentsLabel.text = post.numCommentsString
        self.unreadIndicatorWidth.constant = post.wasRead ? 0 : unreadIndicatorSideSize
        self.unreadIndicatorTrailing.constant = post.wasRead ? 0 : unreadIndicatorRightMargin
        
        if post.thumbnailLink != nil, let width = post.thumbnailWidth, let height = post.thumbnailHeight {
            let ratio = CGFloat(width) / CGFloat(height)
            let newHeight = self.contentView.frame.size.width / ratio
            thumbnailHeightConstraint.constant = newHeight
        }
    }
    
    @IBAction func onDismissTapped(_ sender: Any) {
        onDismiss()
    }
}
