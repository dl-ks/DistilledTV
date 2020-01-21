//
//  HomeViewController.swift
//  DistilledTV
//
//  Created by Barry on 21/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import UIKit

protocol HomeView: class {
    func presentPopularShowsViewController()
}

class HomeViewController: UIViewController {
    
    var presenter: HomePresenter?
    
    private var getShowsButton: UIButton = {
        let btn = UIButton()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setup() {
        view.addSubview(getShowsButton)
    }
    
}

extension HomeViewController: HomeView {
    @objc func presentPopularShowsViewController() {
        presenter?.presentPopularShowsViewController()
    }
}

