//
//  UIViewController+Alert.swift
//  CFTTest
//
//  Created by Денис Лебедько on 11/12/2018.
//  Copyright © 2018 Денис Лебедько. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            ac.addAction(action)
        }
        present(ac, animated: true)
    }
}
