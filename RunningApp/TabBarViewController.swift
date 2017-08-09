//
//  TabBarViewController.swift
//  RunningApp
//
//  Created by Jesse Bartola on 8/8/17.
//  Copyright © 2017 runners. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addRightBarButton()
    }
    
    func addRightBarButton() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "map_marker"), style: .plain, target: self, action: #selector(MapViewController.addLocation))
        
    }
}
