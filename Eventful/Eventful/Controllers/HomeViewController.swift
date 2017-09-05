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
import EZSwipeController

class HomeViewController: EZSwipeController {
    let dropDownLauncher = DropDownLauncher()
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        // setupView()
    //    }
    
    
    override func setupView() {
        datasource = self
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController: EZSwipeControllerDataSource {
    func viewControllerData() -> [UIViewController] {
        
        
        let layout = UICollectionViewFlowLayout()
        let homeFeedController = HomeFeedController(collectionViewLayout: layout)
        
        
        let profileView = ProfileeViewController(collectionViewLayout: layout)
        
        
        let searchController = EventSearchController(collectionViewLayout: UICollectionViewFlowLayout())
        return [searchController, homeFeedController, profileView]
    }
    
    func titlesForPages() -> [String] {
        return ["", "Home", ""]
    }
    
    func navigationBarDataForPageIndex(_ index: Int) -> UINavigationBar {
        var title = ""
        if index == 0 {
            title = ""
        } else if index == 1 {
            title = "Home"
        } else if index == 2 {
            title = ""
        }
        
        let navigationBar = UINavigationBar()
        navigationBar.barStyle = UIBarStyle.default
        //        navigationBar.barTintColor = QorumColors.WhiteLight
        print(navigationBar.barTintColor ?? "")
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        
        let navigationItem = UINavigationItem(title: title)
        navigationItem.hidesBackButton = true
        
        if index == 0 {
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = nil
            navigationBar.isHidden = true
        } else if index == 1 {
            var menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(GoBack))
            navigationItem.leftBarButtonItem = menuButton
            navigationItem.rightBarButtonItem = nil
            
        } else if index == 2 {
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = nil
            navigationBar.isHidden = true
        }
        navigationBar.pushItem(navigationItem, animated: false)
        return navigationBar
    }
    
    func disableSwipingForLeftButtonAtPageIndex(_ index: Int) -> Bool {
        if index == 1 {
            return true
        }
        return false
    }
    
    func clickedLeftButtonFromPageIndex(_ index: Int) {
        if index == 1 {
            print("Left Button Clicked")
            dropDownLauncher.showDropDown()
        }
    }
    
    
    
    func GoBack() {
        print("Button pressed")
    }
    
    func indexOfStartingPage() -> Int {
        return 1
    }
}
