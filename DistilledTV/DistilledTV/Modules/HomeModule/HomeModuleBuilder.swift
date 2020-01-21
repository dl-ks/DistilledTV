//
//  HomeModuleBuilder.swift
//  DistilledTV
//
//  Created by Barry on 21/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation
import UIKit

class HomeModuleBuilder {
    
    static func build() -> UIViewController {
        let view = HomeViewController()
        let router = HomeDefaultRouter(view: view)
        let presenter = HomeDefaultPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
}
