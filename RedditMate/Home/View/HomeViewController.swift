//
//  ViewController.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/5/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, Storyboarded {
    
    weak var coordinator: PostsCoordinator?
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Post>
    typealias DataSource = UITableViewDiffableDataSource<Section, Post>
    
    lazy var presenter: HomePresenter = HomePresenter(view: self)
    
    var dataSource: DataSource!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        configureTableDataSource()
        presenter.fetchPosts()
    }
    
    func configureTableView() {
        let postCellNib = UINib(nibName: String(describing: PostTableViewCell.self), bundle: nil)
        
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.register(postCellNib, forCellReuseIdentifier: PostTableViewCell.identifier)
    }
    
    func configureNavigationBar() {
        self.title = "Reddit Posts"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bin.xmark"), style: .plain, target: self, action: #selector(dismissAllButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.systemGray
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @objc func dismissAllButtonTapped() {
        let alert = UIAlertController(title: "Reddit", message: "Dismissing posts cannot be undone. Do you want to continue?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { _ in
            self.presenter.allPostsDimissed()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: MVP View implementation

extension HomeViewController: HomeView {
    
    func showPosts(_ posts: [Post], animated: Bool) {
        updatePosts(posts, animated: animated)
    }
    
    func showPostDetail(post: Post) {
        self.coordinator?.showPostDetail(post: post)
    }
}

// MARK: Table View diffable data source

extension HomeViewController {
    
    enum Section {
        case main
    }
    
    func configureTableDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Post>(tableView: self.tableView) {
            (tableView: UITableView, indexPath: IndexPath, post: Post) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            
            cell.configure(withPost: post)
            cell.onDismiss = { [weak self] in
                self?.presenter.postDismissed(uuid: post.identifier)
            }
            
            if let thumbnail = post.thumbnailLink {
                let token = self.presenter.fetchPostImage(urlString: thumbnail) { image in
                    DispatchQueue.main.async {
                        cell.thumbnailImageView.image = image
                    }
                }
                
                cell.onReuse = { [weak self] in
                    self?.presenter.cancelPostImageFetch(token: token)
                }
            }
            return cell
        }
    }
    
    func updatePosts(_ posts: [Post], animated: Bool) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(posts)
        dataSource.apply(snapshot, animatingDifferences: animated)
        
        navigationItem.rightBarButtonItem?.isEnabled = !posts.isEmpty
    }
}

// MARK: Table View Delegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.postSelected(index: indexPath.row)
    }
}
