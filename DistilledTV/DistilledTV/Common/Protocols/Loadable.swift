//
//  ActivityIndicatorPresenter.swift
//  DistilledTV
//
//  Created by Barry on 20/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation
import UIKit

protocol Loadable: class {
    var activityIndicator: UIActivityIndicatorView { get }
    func showActivity()
    func hideActivity()
}

extension Loadable where Self: UIViewController {
    func showActivity() {
        DispatchQueue.main.async {
            self.activityIndicator.color = .black
            self.activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 120.0, height: 120.0)
            self.activityIndicator.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.size.height / 2)
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideActivity() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
}
