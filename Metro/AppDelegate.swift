//
//  AppDelegate.swift
//  Metro
//
//  Created by Iaroslav Mamalat on 2018-06-17.
//  Copyright © 2018 Iaroslav Mamalat. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor(named: "Background")
        return window
    }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if let path = Realm.Configuration.defaultConfiguration.fileURL?.path,
            !FileManager.default.fileExists(atPath: path) {
            MTRSeed.shared.seed()
        }

        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 2) {

                    DispatchQueue.main.async {
                        let realm = try! Realm()

                        try! realm.write {
                            realm.delete(realm.objects(MTRStation.self))
                            realm.delete(realm.objects(MTRLine.self))
                        }
                        MTRSeed.shared.seed()
                    }

//
//                    // Nothing to do!
//                    // Realm will automatically detect new properties and removed properties
//                    // And will update the schema on disk automatically
                }
            }
        )

        Realm.Configuration.defaultConfiguration = config
        try? Realm()

        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor(named: "Black")
        ]
    
        UINavigationBar.appearance().barTintColor = UIColor(named: "White")
        let navigation = UINavigationController(rootViewController: MTRSearchViewController())

        navigation.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor(named: "Black")
        ]

        navigation.navigationBar.prefersLargeTitles = true

        // Shadow image: bottom border
        // UINavigationBar.appearance().shadowImage = UIImage()

        window?.rootViewController = navigation
//        window?.rootViewController = MTRMapViewController()
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active
        // to inactive state. This can occur for certain types of
        // temporary interruptions (such as an incoming phone call or
        // SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers,
        // and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data,
        // invalidate timers, and store enough application state information
        // to restore your application to its current state in case it is terminated later.
        // If your application supports background execution,
        // this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to
        // the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive.
        // If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate.
        // Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
