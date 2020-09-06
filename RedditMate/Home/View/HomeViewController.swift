//
//  ViewController.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/5/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    lazy var presenter: HomePresenter = HomePresenter(view: self)
    
    var dataSource: DataSource!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // TODO: move to view did load
        presenter.fetchItems()
    }
}

extension HomeViewController: HomeView {
    
    func showItems(_ items: [Item]) {
        updateItems(items)
    }
}

extension HomeViewController {
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section {
        case main
    }
    
    func configureTableView() {
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: String(describing: ItemTableViewCell.self), bundle: nil), forCellReuseIdentifier: ItemTableViewCell.identifier)
        
        dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: self.tableView) {
            (tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as! ItemTableViewCell
            
            cell.configure(withItem: item)
            
            if let thumbnail = item.thumbnail {
                let token = self.presenter.fetchItemImage(urlString: thumbnail) { image in
                    DispatchQueue.main.async {
                        cell.thumbnailImageView.image = image
                    }
                }
                
                cell.onReuse = { [weak self] in
                    self?.presenter.cancelItemImageFetch(token: token)
                }
            }
            return cell
        }
    }
    
    func updateItems(_ items: [Item]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
