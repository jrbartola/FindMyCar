//
//  TabBarViewController.swift
//  RunningApp
//
//  Created by Jesse Bartola on 8/8/17.
//  Copyright © 2017 runners. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = Styles.color(style: .lightBlue)
        navigationItem.title = "Find Your Car"
        //tabBar.backgroundColor = Styles.color(style: .lightBlue)
        //tabBar.barTintColor = Styles.color(style: .lightBlue)
        UITabBar.appearance().tintColor = Styles.color(style: .lightBlue)
//        if let items = tabBar.items {
//            for tab in items {
//                tab.image.
//            }
//        }
        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        // If we clicked on the recent tab, reload the tableview
        if item.title! == "Recent" {
            let locationsViewController = self.viewControllers![0] as! LocationsViewController
            locationsViewController.removeLeftBarButton()
            locationsViewController.removeRightBarButton()
            locationsViewController.locationsTableView.reloadData()
        
        } else if item.title! == "Map" {
            let mapViewController = self.viewControllers![1] as! MapViewController
            mapViewController.addLeftBarButton()
            mapViewController.addRightBarButton()
            
        }
    }

}
