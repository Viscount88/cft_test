//
//  AppWindow.swift
//  CFTTest
//
//  Created by Денис Лебедько on 10/12/2018.
//  Copyright © 2018 Денис Лебедько. All rights reserved.
//

import UIKit

struct AppWindow {
    
    public static var window: UIWindow = {        
        let imageProcessingVC  = ImageProcessingVC(nibName:"ImageProcessingVC", bundle:nil)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = imageProcessingVC
        window.makeKeyAndVisible()
        
        return window
    }()
    
    public static var topViewController: UIViewController? {
        if var topController = AppWindow.window.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        
        return nil
    }
}
