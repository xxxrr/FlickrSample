//
//  Extensions.swift
//  Sample1
//
//  Created by Roopa Raman on 26/1/17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit


extension String {
    
    func urlencode() -> String {
        let stringToEncode = self.replacingOccurrences(of: " ", with: "+")
        return stringToEncode.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
    
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
    
    func hmacsha1(key: String) -> Data {
        let dataToDigest = self.data(using: String.Encoding.utf8)
        let keyData = key.data(using: String.Encoding.utf8)
        
        let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<Any>.allocate(capacity: digestLength)
        
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), (keyData! as NSData).bytes, keyData!.count, (dataToDigest! as NSData).bytes, dataToDigest!.count, result)
        
        return Data(bytes: UnsafePointer(result), count: digestLength)
    }
    
}

