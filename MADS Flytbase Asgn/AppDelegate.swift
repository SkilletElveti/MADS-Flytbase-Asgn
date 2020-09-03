//
//  AppDelegate.swift
//  MADS Flytbase Asgn
//
//  Created by Shubham Vinod Kamdi on 03/09/20.
//  Copyright © 2020 Persausive Tech. All rights reserved.
//

import UIKit
import FirebaseCore

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        redirect()
        return true
    }

    func redirect(){
        if UserDefaults.standard.bool(forKey: Constant.IS_LOGGED_IN){
        
            let frame = UIScreen.main.bounds
            window = UIWindow(frame: frame)
            let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
            window?.rootViewController = VC
            window?.makeKeyAndVisible()
            
        }else{
            
            let frame = UIScreen.main.bounds
            window = UIWindow(frame: frame)
            let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            window?.rootViewController = VC
            window?.makeKeyAndVisible()
        }
    }
    
    // MARK: UISceneSession Lifecycle

}

