//
//  NavigationBuilder.swift
//  DistilledTV
//
//  Created by Barry on 22/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation
import UIKit

class NavigationBuilder {
    static func build(root: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: root)
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        return navigationController
    }
}
