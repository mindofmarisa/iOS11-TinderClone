//
//  AppDelegate.swift
//  TinderClone
//
//  Created by Kenneth Nagata on 5/26/18.
//  Copyright © 2018 Kenneth Nagata. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        configureParse()
        
        return true
    }
    
    // Func to retrieve parse clientId and Key from plist
    func valueForAPIKey(named keyname:String) -> String {
        let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
        let plist = NSDictionary(contentsOfFile:filePath!)
        let value = plist?.object(forKey: keyname) as! String
        return value
    }
    
    // Configure parse server for AWS
    func configureParse(){
        
        // Retrieve id/key for parse server
        let clientID = valueForAPIKey(named:"AWS_CLIENT_ID")
        let clientKey = valueForAPIKey(named: "AWS_SECRET")
        
        // Set up configuration for parse server
        let configuration = ParseClientConfiguration {
            $0.applicationId = clientID
            $0.clientKey = clientKey
            $0.server = "http://ec2-18-221-131-183.us-east-2.compute.amazonaws.com/parse"
        }
        Parse.initialize(with: configuration)
    }
    
    


}

