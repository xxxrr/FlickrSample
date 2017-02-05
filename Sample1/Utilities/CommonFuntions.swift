//
//  CommonFuntions.swift
//  Sample1
//
//  Created by Roopa Raman on 4/2/17.
//  Copyright © 2017  . All rights reserved.
//

import Foundation
import UIKit
class CommonFunctions {
    static func applyLowShadowToViewLayer(_ viewLayer: CALayer, bounds: CGRect){
        viewLayer.shadowColor = UIColor.white.cgColor
        viewLayer.shadowOpacity = 0.5
        viewLayer.shadowOffset = CGSize.zero
        viewLayer.shadowRadius = 50
        viewLayer.shadowPath = UIBezierPath(rect: bounds).cgPath
        viewLayer.shouldRasterize = true
    }
}
