//
//  UIViewController.swift
//  reign
//
//  Created by Beto Salcido on 04/10/20.
//  Copyright © 2020 BetoSalcido. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /// Method to add the loadingView
    func showLoadingView(transparent: Bool = false) {
        let container = UIView()
        let activityIndicator = UIActivityIndicatorView()
        
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = transparent ? UIColor.clear :UIColor.black.withAlphaComponent(0.5)
        container.tag = 10000
        
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0);
        if #available(iOS 13.0, *) {
            activityIndicator.style = UIActivityIndicatorView.Style.large
        }
        activityIndicator.center = view.center
        activityIndicator.tag = 11000
        
        container.addSubview(activityIndicator)
        view.addSubview(container)
        activityIndicator.startAnimating()
        
    }
    
    /// Method to remove a loadingView
    func removeLoadingView() {
        for view in view.subviews {
            if (view.tag == 10000) {
                view.removeFromSuperview()
            }
        }
        
    }
}
