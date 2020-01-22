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
        return navigationController
    }
}
