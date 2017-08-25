//
//  HomeViewController.swift
//  Eventful
//
//  Created by Shawn Miller on 7/27/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         setupView()
        
    }

    
    
    // Things that I need to appear everytime will be in viewWillAppear
    func setupView( ) {
        let layout = UICollectionViewFlowLayout()
        let homeFeedController = HomeFeedController(collectionViewLayout: layout)
        
        // let viewController = HomeFeedController()
        let navController = UINavigationController(rootViewController: homeFeedController)
        navController.navigationBar.isTranslucent = false
        navController.tabBarItem.image = UIImage(named: "icons8-Home-50")
        navController.tabBarItem.selectedImage = UIImage(named: "icons8-Home Filled-50")

        
        //ProfileeViewController being setup and added to array of view controllers
        
        let profileView = ProfileeViewController(collectionViewLayout: layout)
        
        let profileViewNavController = UINavigationController(rootViewController: profileView)
        profileViewNavController.navigationBar.isTranslucent = false
        profileViewNavController.tabBarItem.image = UIImage(named: "icons8-User-50")
        profileViewNavController.tabBarItem.selectedImage = UIImage(named: "icons8-User Filled-50")
        
        
        let searchController = EventSearchController(collectionViewLayout: UICollectionViewFlowLayout())
        let searchNavController = UINavigationController(rootViewController: searchController)
        searchNavController.tabBarItem.image = UIImage(named: "icons8-Search-48")

        
        // array of view controllers
        viewControllers = [navController,searchNavController, profileViewNavController]
        
        guard let items = tabBar.items else {
            return
        }
        
        for item in items{
            item.imageInsets = UIEdgeInsetsMake(4, 0, 0, -4)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // will check if a user is logged in by checking value of current user
    
    
}
