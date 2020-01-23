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
        navigationController.navigationBar.barStyle = .default
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.prefersLargeTitles = true

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "customBlue")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        let backButtonAppearence = UIBarButtonItemAppearance()
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        backButtonAppearence.normal.titleTextAttributes = titleTextAttributes
        backButtonAppearence.highlighted.titleTextAttributes = titleTextAttributes
        appearance.backButtonAppearance = backButtonAppearence
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        return navigationController
    }
}
