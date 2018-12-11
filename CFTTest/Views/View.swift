//
//  View.swift
//  CFTTest
//
//  Created by Денис Лебедько on 05/12/2018.
//  Copyright © 2018 Денис Лебедько. All rights reserved.
//

import UIKit

enum View: String {
    case resultImageCell = "ResultImageTVC"
    case progressCell = "ProgressTVC"
    
    var className: String {
        return Constants.moduleName.appending(".").appending(rawValue)
    }
    
    var clazz: AnyClass? {
        return NSClassFromString(className)
    }
    
    func instantiate() -> UINib? {
        let bundle = Bundle.main
        if bundle.path(forResource: rawValue, ofType: "nib") != nil {
            return UINib(nibName: rawValue, bundle: nil)
        } else {
            return nil
        }
    }
    
    func defaultHeight() -> CGFloat {
        switch self {
        default:
            return 0
        }
    }
}

// MARK: - UITableView support

extension UITableView {
    
    func registerCell(_ view: View) {
        if let nib = view.instantiate() {
            register(nib, forCellReuseIdentifier: view.rawValue)
        } else if let clazz = view.clazz {
            register(clazz, forCellReuseIdentifier: view.rawValue)
        } else {
            fatalError("couldn't register cell \(self)")
        }
    }
    
    func registerHeaderFooter(_ view: View) {
        if let nib = view.instantiate() {
            register(nib, forHeaderFooterViewReuseIdentifier: view.rawValue)
        } else if let clazz = view.clazz {
            register(clazz, forHeaderFooterViewReuseIdentifier: view.rawValue)
        } else {
            fatalError("couldn't register cell \(self)")
        }
    }
    
    func dequeueReusableCell(of view: View) -> UITableViewCell? {
        return dequeueReusableCell(withIdentifier: view.rawValue)
    }
    
    func dequeueReusableCell(of view: View, for indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(withIdentifier: view.rawValue, for: indexPath)
    }
    
    func dequeueReusableHeaderFooter(of view: View) -> UITableViewHeaderFooterView? {
        return dequeueReusableHeaderFooterView(withIdentifier: view.rawValue)
    }
}

