//
//  LocationsTableViewCell.swift
//  RunningApp
//
//  Created by Jesse Bartola on 7/25/17.
//  Copyright © 2017 runners. All rights reserved.
//

import UIKit

class LocationsTableViewCell: UITableViewCell {
    
    var tableView: UITableView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Item"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupViews() {
        addSubview(addressLabel)
        addSubview(actionButton)
        
        //actionButton.addTarget(self, action: #selector(MyCell.handleAction), for: .touchUpInside)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-8-[v1(80)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": addressLabel, "v1": actionButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": addressLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": actionButton]))
    }
    
    @objc func handleAction() {
        //myTableViewController?.deleteCell(cell: self)
    }
}
