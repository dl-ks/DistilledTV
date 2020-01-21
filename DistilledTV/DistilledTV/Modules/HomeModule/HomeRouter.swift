//
//  HomeRouter.swift
//  DistilledTV
//
//  Created by Barry on 21/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation
import UIKit

protocol HomeRouter {
    func presentPopularShowsViewController()
}

class HomeDefaultRouter {
    
    var view: UIViewController
    
    init(view: UIViewController) {
        self.view = view
    }
}

extension HomeDefaultRouter: HomeRouter {
    func presentPopularShowsViewController() {
        view.navigationController?.present(PopularShowsModuleBuilder.build(), animated: true, completion: nil)
    }
}
