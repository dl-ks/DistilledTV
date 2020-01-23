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
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor(named: "customGreen")
        btn.setTitleColor(UIColor(named: "customGrey"), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir", size: 36.0)
        btn.layer.cornerRadius = 8.0
        btn.setTitle("get_popular_shows".localized, for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setup() {
        getShowsButton.addTarget(self,
                                 action: #selector(presentPopularShowsViewController),
                                 for: .touchUpInside)
        view.backgroundColor = UIColor(named: "customBlue")
        view.addSubview(getShowsButton)
    }
    
    private func setupConstraints() {
        getShowsButton.center(in: view)
        getShowsButton.width(300.0)
        getShowsButton.height(50.0)
    }
}

extension HomeViewController: HomeView {
    @objc func presentPopularShowsViewController() {
        presenter?.presentPopularShowsViewController()
    }
}

