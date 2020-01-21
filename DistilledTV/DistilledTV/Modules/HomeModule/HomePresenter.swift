//
//  HomePresenter.swift
//  DistilledTV
//
//  Created by Barry on 21/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation
import UIKit

protocol HomePresenter {
    func presentPopularShowsViewController()
}

class HomeDefaultPresenter {
    
    weak var view: HomeView?
    var router: HomeRouter
    
    init(view: HomeView, router: HomeRouter) {
        self.view = view
        self.router = router
    }
}

extension HomeDefaultPresenter: HomePresenter {
    func presentPopularShowsViewController() {
        router.presentPopularShowsViewController()
    }
}
