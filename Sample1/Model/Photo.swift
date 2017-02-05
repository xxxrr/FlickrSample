//
//  Photo.swift
//  Sample1
//
//  Created by Roopa Raman on 2/2/17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit

class Photo: NSObject {
    /*
     "id": "3729689790",
     "owner": "40318902@N02",
     "secret": "ea9c38a675",
     "server": "3466",
     "farm": 4,
     "title": "opac",
     "ispublic": 1,
     "isfriend": 0,
     "isfamily": 0
     */
    
    var id : String = ""
    var owner : String = ""
    var secret : String = ""
    var server : String = ""
    var farm :String = ""
    var title : String = ""
    var ispublic : Bool = true
    var isFriend : Bool = false
    var isFamily : Bool = false
    var url : URL!
    var photo : UIImage!
    
    override init() {
        super.init()
    }
    
    init(id : String, owner : String, secret : String, server : String, farm :String, title : String, ispublic : Bool, isFriend : Bool, isFamily : Bool){
        self.id = id
        self.owner = owner
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = title
        self.isFamily = isFamily
        self.ispublic = ispublic
        self.isFriend = isFriend //"http://farm" + data.photos.photo[i].farm + ".static.flickr.com/" + data.photos.photo[i].server + "/"+data.photos.photo[i].id + "_"+data.photos.photo[i].secret + ".jpg
        self.url = URL(string: "http://farm" + self.farm + ".static.flickr.com/" + self.server + "/" + self.id + "_" + self.secret + ".jpg")! //URL

    }
    func heightForComment(font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: title).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
}
