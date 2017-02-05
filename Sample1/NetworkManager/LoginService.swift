//
//  LoginService.swift
//  Sample1
//
//  Created by Roopa Raman on 26/1/17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit
let API_KEY = "0e3549a8d4232e3137b824b12a694bc3"
let API_SECRET = "70140d06492ff367"
class LoginService: NSObject {
    func getRequestToken(success : @escaping (_ response : [String:String]) -> Void){
        
        let url = "https://www.flickr.com/services/oauth/request_token"
        let encodedUrl = ("https://www.flickr.com/services/oauth/request_token").stringByAddingPercentEncodingForRFC3986()
        let callBackUrl = ("http://localhost").stringByAddingPercentEncodingForRFC3986()
        let uniqueValue = UUID().uuidString
        let seconds = Int(NSDate().timeIntervalSince1970)
        let baseString = "\(url)" + "?oauth_callback=\(callBackUrl!)" + "&oauth_consumer_key=\(API_KEY)" + "&oauth_nonce=\(uniqueValue)" + "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=\(seconds)&oauth_version=1.0"
         let hashableString = "oauth_callback=\(callBackUrl!)" + "&oauth_consumer_key=\(API_KEY)" + "&oauth_nonce=\(uniqueValue)" + "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=\(seconds)&oauth_version=1.0"
        let baseStringFormatted = "GET&" + "\(encodedUrl!)&" + hashableString.stringByAddingPercentEncodingForRFC3986()!
        let hashedSignature = baseStringFormatted.hmacsha1(key: "\(API_SECRET)&").base64EncodedString()
        
        print(hashedSignature)
        
        let requestTokenString = "\(baseString)&oauth_signature=\(hashedSignature)"
        NetworkManager.nsurlGet(url: requestTokenString) { (response) in
            success(response)
        }
    }
    
    func getAccessToken(oAuthToken: String, oAuthVerifier: String, oAuthTokenSecret : String ,success : @escaping (_ response : [String:String]) -> Void){
        
        let url = "https://www.flickr.com/services/oauth/access_token"
        let encodedUrl = ("https://www.flickr.com/services/oauth/access_token").stringByAddingPercentEncodingForRFC3986()
        
        let uniqueValue = UUID().uuidString
        let seconds = Int(NSDate().timeIntervalSince1970)
        //The parameter has to be in alphabetical order when you hash it
        let baseString = "\(url)" + "?oauth_consumer_key=\(API_KEY)" + "&oauth_nonce=\(uniqueValue)" +  "&oauth_signature_method=HMAC-SHA1" + "&oauth_timestamp=\(seconds)" + "&oauth_token=\(oAuthToken)" + "&oauth_verifier=\(oAuthVerifier)" + "&oauth_version=1.0"
    
        let hashableString = "oauth_consumer_key=\(API_KEY)" + "&oauth_nonce=\(uniqueValue)" +  "&oauth_signature_method=HMAC-SHA1" + "&oauth_timestamp=\(seconds)" + "&oauth_token=\(oAuthToken)" + "&oauth_verifier=\(oAuthVerifier)" + "&oauth_version=1.0"
        let baseStringFormatted = "GET&" + "\(encodedUrl!)&" + hashableString.stringByAddingPercentEncodingForRFC3986()!
        let hashedSignature = baseStringFormatted.hmacsha1(key: "\(API_SECRET)&\(oAuthTokenSecret)").base64EncodedString()
        
        print(hashedSignature)
        
        let requestTokenString = "\(baseString)&oauth_signature=\(hashedSignature)"
        NetworkManager.nsurlGet(url: requestTokenString) { (response) in
            success(response)
        }
    }

}
