//
//  ActivityIndicator.swift
//  Sample1
//
//  Created by Roopa Raman on 4/2/17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicatorView {
    var view : UIView!
    var activityIndicator: UIActivityIndicatorView!
    var titleLabel: UILabel!
    
    init(center:CGPoint, width: CGFloat = 180.0, height: CGFloat = 50.0){
        let x = center.x - width/2.0
        let y = center.y - width/2.0
        
        self.view = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        self.view.backgroundColor = UIColor.lightGray
        self.view.layer.cornerRadius = 10
        
//        CommonFunctions.applyLowShadowToViewLayer(self.view.layer)
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.activityIndicator.color = UIColor.black
        self.activityIndicator.hidesWhenStopped = false
        
        titleLabel = UILabel(frame: CGRect(x: 55, y: 0, width: 200, height: 50))
        titleLabel.text = ""
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 13.0)
        
        self.view.addSubview(self.activityIndicator)
        self.view.addSubview(self.titleLabel)
    }
    
    func getActivityIndicatorWithTitle(_ title:String) -> UIView{
        titleLabel.text = title
        return self.view
    }
    
    func startAnimating(){
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    func stopAnimating(){
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        self.view.removeFromSuperview()
    }
    func startAnimatingWithInteractionsAllowed(){
        self.activityIndicator.startAnimating()
    }
    func stopAnimatingWithInteractionsAllowed(){
        self.activityIndicator.stopAnimating()
        self.view.removeFromSuperview()
    }
    
}
