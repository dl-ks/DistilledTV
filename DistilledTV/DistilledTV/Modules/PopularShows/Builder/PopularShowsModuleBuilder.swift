//
//  ShowsModuleBuilder.swift
//  DistilledTV
//
//  Created by Barry on 21/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation
import UIKit

class PopularShowsModuleBuilder {
    static func build() -> UIViewController {
        let view = PopularShowsViewController()
        let interactor = PopularShowsDefaultInteractor(network: PopularShowsClient())
        let router = PopularShowsDefaultRouter(view: view)
        let presenter = PopularShowsDefaultPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        return view
    }
}
