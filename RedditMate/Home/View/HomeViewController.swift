//
//  ViewController.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/5/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias DataSource = UITableViewDiffableDataSource<Section, Item>
    
    lazy var presenter: HomePresenter = HomePresenter(view: self)
    
    var dataSource: DataSource!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureTableDataSource()
        presenter.fetchItems()
    }
    
    func configureTableView() {
        let itemCellNib = UINib(nibName: String(describing: ItemTableViewCell.self), bundle: nil)
        
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.register(itemCellNib, forCellReuseIdentifier: ItemTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// MARK: MVP View implementation

extension HomeViewController: HomeView {
    
    func showItems(_ items: [Item]) {
        updateItems(items)
    }
    
    func showItemDetail(item: Item) {
        self.coordinator?.showPostDetail(post: item)
    }
}

// MARK: Table View diffable data source

extension HomeViewController {
    
    enum Section {
        case main
    }
    
    func configureTableDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: self.tableView) {
            (tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as! ItemTableViewCell
            
            cell.configure(withItem: item)
            cell.onDismiss = { [weak self] in
                self?.presenter.itemDismissed(index: indexPath.row)
            }
            
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

// MARK: Table View Delegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.itemSelected(index: indexPath.row)
    }
}
