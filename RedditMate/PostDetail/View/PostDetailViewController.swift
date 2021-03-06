//
//  PostDetailViewController.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/7/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subredditLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var upVotesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    lazy var presenter = PostDetailPresenter(view: self)
    
    weak var coordinator: PostsCoordinator?
    
    var post: Post?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        guard let post = self.post else {
            return
        }
        
        presenter.setupViewWithPost(post)
    }
    
    @IBAction func expandImageButtonTapped(_ sender: Any) {
        self.presenter.expandImage()
    }
    
    @IBAction func downloadImageButtonTapped(_ sender: Any) {
        self.presenter.downloadImage()
    }
}

// MARK: MVP View - PostDetailView

extension PostDetailViewController: PostDetailView {
    
    func setDate(text: String) {
        self.dateLabel.text = text
    }
    
    func setTitle(text: String) {
        self.titleLabel.text = text
    }
    
    func setAuthor(text: String) {
        self.userNameLabel.text = text
    }
    
    func setSubreddit(text: String) {
        self.subredditLabel.text = text
    }
    
    func setUpvotes(text: String) {
        self.upVotesLabel.text = text
    }
    
    func setComments(text: String) {
        self.commentsLabel.text = text
    }
    
    func setImage(_ image: UIImage) {
        self.imageContainer.isHidden = false
        self.imageActivityIndicator.stopAnimating()
        self.imageView.image = image
    }
    
    func setImageSize(ratio: Float) {
        let newHeight = self.imageView.frame.size.width / CGFloat(ratio)
        self.imageHeightConstraint.constant = newHeight
    }
    
    func showImageLoading() {
        self.imageActivityIndicator.startAnimating()
    }
    
    func getImage() -> UIImage? {
        return self.imageView.image
    }
    
    func showFullScreenImage(url: URL) {
        self.coordinator?.showFullScreenImage(url: url)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Reddit", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
