//
//  PopularShowsRouter.swift
//  DistilledTV
//
//  Created by Barry on 21/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation
import UIKit

protocol PopularShowsRouter {
    func showActivity()
    func hideActivity()
}

class PopularShowsDefaultRouter {
    let view: UIViewController & Loadable
    
    init(view: UIViewController & Loadable) {
        self.view = view
    }
}

extension PopularShowsDefaultRouter: PopularShowsRouter {
    func showActivity() {
        view.showActivity()
    }
    
    func hideActivity() {
        view.hideActivity()
    }
}
