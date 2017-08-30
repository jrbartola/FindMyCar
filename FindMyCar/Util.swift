//
//  Util.swift
//  RunningApp
//
//  Created by Jesse Bartola on 8/27/17.
//  Copyright © 2017 runners. All rights reserved.
//

import UIKit

class Util {
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    public static func parseDate(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "MMM dd yyyy hh:mm a"
        return df.string(from: date)
    }
    
    public static func showActivityIndicator(uiView: UIView, container: UIView, loadingView: UIView, activityIndicator: UIActivityIndicatorView, text: String?) {
        
        //var container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = .clear//UIColor(hex: "0xffffff", alpha: 0.3)
        
        //var loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(hex: "0x444444", alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd: UIActivityIndicatorView = activityIndicator
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2)
        
        let loadingLabel = UILabel()
        loadingLabel.text = text ?? "Loading"
        loadingLabel.textColor = .white//Styles.color(style: .lightBlue)
        //loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.frame = CGRect(x: 0.0, y: 0.0, width: 70.0, height: 10.0)
        loadingLabel.center = CGPoint(x: loadingView.frame.size.width / 2,
                                      y: loadingView.frame.size.height / 2 + 30)
        loadingLabel.font = UIFont(name: loadingLabel.font.fontName, size: 9.0)
        loadingLabel.textAlignment = .center
        
        loadingView.addSubview(loadingLabel)
        loadingView.addSubview(actInd)
        
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
    }
    
    public static func stopActivityIndicator(uiView: UIView, container: UIView, loadingView: UIView, activityIndicator: UIActivityIndicatorView) {
        
        container.removeFromSuperview()
        loadingView.removeFromSuperview()
        activityIndicator.stopAnimating()
    }
}

