//
//  PhotosServiceManager.swift
//  Sample1
//
//  Created by Roopa Raman on 3/2/17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit
class PhotosServiceManager: NSObject {
    
    func getAllPublicRecentPhotos(page : Int, oAuthToken: String, oAuthTokenSecret : String ,success : @escaping (_ response : Array<Photo>) -> Void){
        
        let url = "https://api.flickr.com/services/rest"
        let encodedUrl = ("https://api.flickr.com/services/rest").stringByAddingPercentEncodingForRFC3986()
        
        let uniqueValue = UUID().uuidString
        let seconds = Int(NSDate().timeIntervalSince1970)
        //The parameter has to be in alphabetical order when you hash it
        let baseString = "\(url)" + "?api_key=\(API_KEY)&method=flickr.photos.getRecent" + "&format=json" + "&oauth_consumer_key=\(API_KEY)" + "&oauth_nonce=\(uniqueValue)" +  "&oauth_signature_method=HMAC-SHA1" + "&oauth_timestamp=\(seconds)" + "&oauth_token=\(oAuthToken)" +  "&oauth_version=1.0&per_page=7&page=\(page)"
        
        let hashableString = "api_key=\(API_KEY)&method=flickr.photos.getRecent" + "&format=json" + "&oauth_consumer_key=\(API_KEY)" + "&oauth_nonce=\(uniqueValue)" +  "&oauth_signature_method=HMAC-SHA1" + "&oauth_timestamp=\(seconds)" + "&oauth_token=\(oAuthToken)" +  "&oauth_version=1.0&per_page=7&page=\(page)"
        let baseStringFormatted = "GET&" + "\(encodedUrl!)&" + hashableString.stringByAddingPercentEncodingForRFC3986()!
        let hashedSignature = baseStringFormatted.hmacsha1(key: "70140d06492ff367&\(oAuthTokenSecret)").base64EncodedString()
        
        print(hashedSignature)
        
        let requestTokenString = "\(baseString)&oauth_signature=\(hashedSignature)"
        NetworkManager.nsurlGetPhotos(url: requestTokenString) { (response) in
            let photosFromResponse = self.mapPhotosToModel(photosObj: response)
            success(photosFromResponse)
        }
    }
    
    func getAllYourPhotos(page : Int,oAuthToken: String, oAuthTokenSecret : String ,success : @escaping (_ response : Array<Photo>) -> Void){
        
        let url = "https://api.flickr.com/services/rest"
        let encodedUrl = ("https://api.flickr.com/services/rest").stringByAddingPercentEncodingForRFC3986()
        
        let uniqueValue = UUID().uuidString
        let seconds = Int(NSDate().timeIntervalSince1970)
        //The parameter has to be in alphabetical order when you hash it
        let baseString = "\(url)" + "?api_key=\(API_KEY)&method=flickr.people.getPhotos" + "&format=json" + "&oauth_consumer_key=\(API_KEY)" + "&oauth_nonce=\(uniqueValue)" +  "&oauth_signature_method=HMAC-SHA1" + "&oauth_timestamp=\(seconds)" + "&oauth_token=\(oAuthToken)" +  "&oauth_version=1.0&per_page=7&page=\(page)" + "&user_id=151449567%40N06"
        
        let hashableString = "api_key=\(API_KEY)&method=flickr.people.getPhotos" + "&format=json" + "&oauth_consumer_key=\(API_KEY)" + "&oauth_nonce=\(uniqueValue)" +  "&oauth_signature_method=HMAC-SHA1" + "&oauth_timestamp=\(seconds)" + "&oauth_token=\(oAuthToken)" +  "&oauth_version=1.0&per_page=7&page=\(page)" + "&user_id=151449567%40N06"
        let baseStringFormatted = "GET&" + "\(encodedUrl!)&" + hashableString.stringByAddingPercentEncodingForRFC3986()!
        let hashedSignature = baseStringFormatted.hmacsha1(key: "70140d06492ff367&\(oAuthTokenSecret)").base64EncodedString()
        
        print(hashedSignature)
        
        let requestTokenString = "\(baseString)&oauth_signature=\(hashedSignature)"
        NetworkManager.nsurlGetPhotos(url: requestTokenString) { (response) in
            let photosFromResponse = self.mapPhotosToModel(photosObj: response)
            success(photosFromResponse)
        }
    }
    
    func uploadYourPhoto(oAuthToken: String, oAuthTokenSecret : String ,photo:Data ,success : @escaping (_ response : [String:AnyObject]) -> Void){
        
        let url = "https://up.flickr.com/services/upload/"
        let encodedUrl = ("https://api.flickr.com/services/rest").stringByAddingPercentEncodingForRFC3986()
        
        let uniqueValue = UUID().uuidString
        let seconds = Int(NSDate().timeIntervalSince1970)
        //The parameter has to be in alphabetical order when you hash it
        let baseString = "\(url)" + "?api_key=\(API_KEY)&method=flickr.people.getPhotos" + "&format=json" + "&oauth_consumer_key=\(API_KEY)" + "&oauth_nonce=\(uniqueValue)" +  "&oauth_signature_method=HMAC-SHA1" + "&oauth_timestamp=\(seconds)" + "&oauth_token=\(oAuthToken)" +  "&oauth_version=1.0&per_page=20" + "&user_id=151449567%40N06"
        
        let hashableString = "api_key=\(API_KEY)&method=flickr.people.getPhotos" + "&format=json" + "&oauth_consumer_key=\(API_KEY)" + "&oauth_nonce=\(uniqueValue)" +  "&oauth_signature_method=HMAC-SHA1" + "&oauth_timestamp=\(seconds)" + "&oauth_token=\(oAuthToken)" +  "&oauth_version=1.0&per_page=20" + "&user_id=151449567%40N06"
        let baseStringFormatted = "GET&" + "\(encodedUrl!)&" + hashableString.stringByAddingPercentEncodingForRFC3986()!
        let hashedSignature = baseStringFormatted.hmacsha1(key: "70140d06492ff367&\(oAuthTokenSecret)").base64EncodedString()
        
        print(hashedSignature)
        
        let requestTokenString = "\(baseString)&oauth_signature=\(hashedSignature)"
        NetworkManager.nsurlGetPhotos(url: requestTokenString) { (response) in
            success(response)
        }
    }
    public func uploadPhoto(oAuthToken: String, oAuthTokenSecret : String ,photo:UIImage,success : @escaping (_ response : String) -> Void)
    {
        let uniqueValue = UUID().uuidString
        let encodedUrl = ("https://api.flickr.com/services/upload/").stringByAddingPercentEncodingForRFC3986()
        let seconds = Int(NSDate().timeIntervalSince1970)
        let hashableString = "oauth_consumer_key=\(API_KEY)" + "&oauth_nonce=\(uniqueValue)" + "&oauth_signature_method=HMAC-SHA1" + "&oauth_timestamp=\(seconds)" + "&oauth_token=\(oAuthToken)" + "&oauth_version=1.0"
        let baseStringFormatted = "POST&" + "\(encodedUrl!)&" + hashableString.stringByAddingPercentEncodingForRFC3986()!
        let hashedSignature = baseStringFormatted.hmacsha1(key: "70140d06492ff367&\(oAuthTokenSecret)").base64EncodedString()
        
        print(hashedSignature)
        
        let imageData = UIImageJPEGRepresentation(photo, 1)
        let api_key = "0e3549a8d4232e3137b824b12a694bc3"
        let uniqueBoundaryValue = UUID().uuidString
        
        let request = NSMutableURLRequest()
        let url = "https://api.flickr.com/services/upload/"
        request.url = URL(string: url)!
        request.httpMethod = "POST"
        
        
        let boundary = String("---------------------------\(uniqueBoundaryValue)")
        request.addValue(" multipart/form-data; boundary=\(boundary!)", forHTTPHeaderField: "Content-Type")
        
        let body:NSMutableData = NSMutableData()
        body.append("\r\n--\(boundary!)\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("Content-Disposition: form-data; name=\"oauth_consumer_key\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(api_key)\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary!)\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("Content-Disposition: form-data; name=\"oauth_token\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(oAuthToken)\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary!)\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("Content-Disposition: form-data; name=\"oauth_signature\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(hashedSignature)\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary!)\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("Content-Disposition: form-data; name=\"oauth_signature_method\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("HMAC-SHA1\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary!)\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("Content-Disposition: form-data; name=\"oauth_nonce\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(uniqueValue)\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary!)\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("Content-Disposition: form-data; name=\"oauth_timestamp\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(seconds)\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary!)\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("Content-Disposition: form-data; name=\"oauth_version\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("1.0\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary!)\r\n".data(using: String.Encoding.utf8)!)
        
        body.append(String("Content-Disposition: form-data; name=\"photo\"; filename=\"Sample.jpg\"\r\n").data(using: String.Encoding.utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
        
        body.append(imageData!)
        body.append("\r\n--\(boundary!)--".data(using: String.Encoding.utf8)!)
        
        request.httpBody = Data(body.subdata(with: NSRange(location: 0, length: body.length)))
        
        
        print(request.httpBody?.count ?? "")
        request.setValue("\(request.httpBody!.count)", forHTTPHeaderField: "Content-Length")
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest,
                                    completionHandler: {(data, response, error) in
                                        if let error = error {
                                            print(error)
                                        }
                                        if let data = data{
                                            print("data =\(data)")
                                        }
                                        if let response = response {
                                            print("url = \(response.url!)")
                                            print("response = \(response)")
                                            let httpResponse = response as! HTTPURLResponse
                                            print("response code = \(httpResponse.statusCode)")
                                            print("DATA = \(data)")
                                            var responseData = String(data: data!, encoding: String.Encoding.utf8)
                                            
                                            //if you response is json do the following
                                            do{
                                                let resultJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
                                                let arrayJSON = resultJSON as! NSArray
                                                for value in arrayJSON{
                                                    let dicValue = value as! NSDictionary
                                                    for (key, value) in dicValue {
                                                        print("key = \(key)")
                                                        print("value = \(value)")
                                                    }
                                                }
                                                
                                            }catch _{
                                                print("Received not-well-formatted JSON")
                                            }
                                            success(responseData!)
                                        }
        })
        task.resume()
    }
    
    
    func mapPhotosToModel(photosObj: [String:AnyObject]) -> Array<Photo> {
        let photosData = photosObj["photos"] as! Dictionary<String,AnyObject>
        let photos = photosData["photo"] as! [[String:AnyObject]]
        var photosFormatted : [Photo] = Array()
        for(_,photo) in photos.enumerated(){
            
            photosFormatted.append(parse(photo)!)
        }
        return photosFormatted
    }
    func parse(_ json: [String: AnyObject]) -> Photo? {
        let id = json["id"] as? String ?? ""
        let owner = json["owner"] as? String ?? ""
        let secret = json["secret"] as? String ?? ""
        let server = json["server"] as? String ?? ""
        let farm =  "\(json["farm"]!)"
        let title = json["title"] as? String ?? ""
        let isPublic = (json["ispublic"])!.boolValue!
        let isFriend = (json["isfriend"])!.boolValue!
        let isFamily = (json["isfamily"])!.boolValue!
        
        return Photo(id: id, owner: owner, secret: secret, server: server, farm: farm, title: title, ispublic: isPublic, isFriend: isFriend, isFamily: isFamily)
    }

}
