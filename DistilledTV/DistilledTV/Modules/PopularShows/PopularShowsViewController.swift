//
//  TvShowsViewController.swift
//  DistilledTV
//
//  Created by Barry on 20/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import UIKit
import TinyConstraints

protocol PopularShowsView: class {
    func display(_ shows: [PopularShow]?)
    func display(_ error: String)
    func display(_ image: UIImage, for show: PopularShow)
    func sort()
}

class PopularShowsViewController: UIViewController, Loadable {

    var activityIndicator = UIActivityIndicatorView()
    var spinner = UIActivityIndicatorView(style: .large)

    var presenter: PopularShowsPresenter? 
    var shows: [PopularShow]?
    
    private var tableView: UITableView = {
        let tbl = UITableView()
        tbl.register(PopularShowsTableViewCell.self, forCellReuseIdentifier: "ShowTableViewCell")
        tbl.estimatedRowHeight = 80.0
        tbl.rowHeight = UITableView.automaticDimension
        return tbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.loadData()
    }
    
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.edges(to: view)
    }
}

extension PopularShowsViewController: PopularShowsView {
    func display(_ shows: [PopularShow]?) {
        self.shows = shows
        tableView.reloadData()
    }
    
    func display(_ image: UIImage, for show: PopularShow) {
        guard let index = shows?.firstIndex(where: { $0.id == show.id && $0.posterPath == show.posterPath }),
            let indexPath = tableView.indexPathsForVisibleRows?.first(where: { $0.row == index }),
            let cell = tableView.cellForRow(at: indexPath) as? PopularShowsTableViewCell else {
                return
        }
        cell.posterImageView.image = image
    }
    
    func display(_ error: String) {
        let alertController = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sort() {
        display(presenter?.sort(shows))
    }
}

extension PopularShowsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ShowTableViewCell") as? PopularShowsTableViewCell,
            let show = shows?[indexPath.row] {
            cell.configure(show)
            cell.posterImageView.image = presenter?.loadImage(for: show)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let shows = shows else { return }
        if indexPath.row == shows.count - 1 {
            presenter?.loadNextPage()
        }
    }
}

