//
//  TvShowsViewController.swift
//  DistilledTV
//
//  Created by Barry on 20/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import UIKit
import TinyConstraints

protocol ShowsListView: class {
    func startLoading()
    func stopLoading()
    func display(_ shows: [Show]?)
    func display(_ error: Error)
}

class ShowsViewController: UIViewController {
    
    lazy var presenter: ShowsPresenter? = { ShowsDefaultPresenter(view: self) }()
    var shows: [Show]?
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.loadData()
    }

}

extension ShowsViewController {
    func setup() {
        view.backgroundColor = .green
        setupTableView()
        setupConstraints()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.edges(to: view)
    }
}

extension ShowsViewController: ShowsListView {
    func display(_ shows: [Show]?) {
        self.shows = shows
        tableView.reloadData()
    }
    
    func display(_ error: Error) {
        
    }
    
    func startLoading() {
        
    }
    
    func stopLoading() {
        
    }
}

extension ShowsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

