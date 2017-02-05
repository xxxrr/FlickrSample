//
//  AdaptiveLayoutAtributes.swift
//  Sample1
//
//  Created by Roopa Raman on 2/2/17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit

class AdaptiveLayoutAtributes: UICollectionViewLayoutAttributes {
    var photoHeight : CGFloat = 0.0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! AdaptiveLayoutAtributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? AdaptiveLayoutAtributes{
            if(attributes.photoHeight == photoHeight){
                return super.isEqual(object)
            }
        }
        return false
    }
}
