//
//  Screen.swift
//  CFTTest
//
//  Created by Александр Лебедько on 10/12/2018.
//  Copyright © 2018 Денис Лебедько. All rights reserved.
//

import UIKit

protocol Screen {
    var title: String? { get }
    var tabBarIcon: UIImage? { get }
    var barTintColor: UIColor? { get }
    var statusBarColor: UIColor { get }
    var navigationBarIsHidden: Bool { get }
    var nibName: String { get }
    var className: String { get }
    
    func prepare(_ vc: UIViewController)
    func prepareForPopSegue(_ vc: UIViewController)
}

extension Screen {
    
    var title: String? {
        switch self {
        default:
            return nil
        }
    }
    
    var tabBarIcon: UIImage? {
        switch self {
        default:
            return nil
        }
    }
    
    var barTintColor: UIColor? {
        switch self {
        default:
            return nil
        }
    }
    
    var navigationBarIsHidden: Bool {
        switch self {
        default:
            return true
        }
    }
    
    var className: String {
        return Constants.moduleName.appending(".").appending(nibName)
    }
    
    var statusBarColor: UIColor {
        switch self {
        default:
            return UIColor.white
        }
    }
    
    func instantiateInNavigationController() -> UINavigationController? {
        guard let vc = instantiate() else {
            return nil
        }
        
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.backgroundColor = barTintColor
        nav.navigationBar.barTintColor = barTintColor
        nav.isNavigationBarHidden = navigationBarIsHidden
        
        return nav
    }
    
    func instantiate() -> UIViewController? {
        guard let clazz = NSClassFromString(className) as? UIViewController.Type else {
            return nil
        }
        
        var vc = UIViewController()
        if !nibName.isEmpty {
            vc = clazz.init(nibName: nibName, bundle: nil)
        } else {
            vc = clazz.init()
        }
        
        prepare(vc)
        
        if let tabBarItem = vc.tabBarItem {
            tabBarItem.image = tabBarIcon
            tabBarItem.selectedImage = tabBarIcon
        }
        
        return vc
    }
    
    func prepare(_ vc: UIViewController) {
        vc.title = title?.uppercased()
    }
    
    func prepareForPopSegue(_ vc: UIViewController) {
        
    }
}
