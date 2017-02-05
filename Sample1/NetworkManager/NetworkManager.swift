//
//  NetworkManager.swift
//  Sample1
//
//  Created by Roopa Raman on 26/1/17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    static func nsurlGet(url : String,success : @escaping (_ response : [String:String]) -> Void){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("error calling GET ")
                print(error ?? "")
                return
            }
            var responseDict : [String:String] = [:]
             let responseData = String(data: data!, encoding: String.Encoding.utf8)
            let responseDataArray : Array<String> = (responseData?.components(separatedBy: "&"))!
            for res in responseDataArray {
                let keyValues = (res ).components(separatedBy: "=")
                responseDict[keyValues[0]] = keyValues[1]
            }
            
            for (key,value) in responseDict {
                print("\(key) : \(value)")
            }
            success(responseDict)
            
        }
        
        task.resume()
        
    }
    
    static func nsurlGetPhotos(url : String,success : @escaping (_ response : [String:AnyObject]) -> Void){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("error calling GET")
                print(error ?? "")
                return
            }
            var responseDict : [String:AnyObject] = [:]
            
            var responseData = String(data: data!, encoding: String.Encoding.utf8)//?.components(separatedBy: "(")[1]
            let rangeofFirstString = responseData?.range(of: "(")
            responseData = responseData?.substring(from: (rangeofFirstString?.upperBound)!)
            let rangeofString = responseData?.range(of: ")", options: .backwards, range: nil, locale: nil)
            responseData =  responseData?.replacingCharacters(in: rangeofString!, with: "")
            //responseData = responseData?.replacingOccurrences(of: ")", with: "")
            if let data = responseData?.data(using: .utf8) {
                do {
                    if let jsonResp = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                    {
                        print(jsonResp)
                        success(jsonResp )
                        
                    }else{
                        
                        let responseDataArray : Array<String> = (responseData?.components(separatedBy: "&"))!
                        for res in responseDataArray {
                            let keyValues = (res ).components(separatedBy: "=")
                            responseDict[keyValues[0]] = keyValues[1] as AnyObject?
                        }
                        
                        for (key,value) in responseDict {
                            print("\(key) : \(value)")
                        }
                        success(responseDict)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            
        }
        
        task.resume()
        
    }
    
    static func uploadPhoto(url : String,success : @escaping (_ response : [String:AnyObject]) -> Void){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        
         let task = session.dataTask(with: request)   { (data, response, error) in
                guard error == nil else {
                    print("error calling GET ")
                    print(error ?? "")
                    return
                }
                
                var responseDict : [String:AnyObject] = [:]
                var responseData = String(data: data!, encoding: String.Encoding.utf8)?.components(separatedBy: "(")[1]
                responseData = responseData?.replacingOccurrences(of: ")", with: "")
                if let data = responseData?.data(using: .utf8) {
                    do {
                        if let jsonResp = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                        {
                            print(jsonResp)
                            success(jsonResp )
                            
                        }else{
                            
                            let responseDataArray : Array<String> = (responseData?.components(separatedBy: "&"))!
                            for res in responseDataArray {
                                let keyValues = (res ).components(separatedBy: "=")
                                responseDict[keyValues[0]] = keyValues[1] as AnyObject?
                            }
                            
                            for (key,value) in responseDict {
                                print("\(key) : \(value)")
                            }
                            success(responseDict)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
                
        }
         task.resume()
    }

}


//let session = URLSession.shared
//
//guard let url = URL(string: urlString) else {
//    completionBlock(false, nil)
//    return
//}
//let task = session.dataTask(with: url) { [weak self] (data, response, error) in
//    guard let strongSelf = self else { return }
//    guard let data = data else {
//        completionBlock(false, error as NSError?)
//        return
//    }
//    let error = NSError()//... // Define a NSError for failed parsing
//    if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: AnyObject]] {
//        guard let jsonData = jsonData else {
//            completionBlock(false,  error)
//            return
//        }
//        var users = [Photo?]()
//        for json in jsonData {
//            if let user = PhotoViewModelController.parse(json) {
//                users.append(user)
//            }
//        }
//        
//        strongSelf.viewModels = PhotoViewModelController.initViewModels(users)
//        completionBlock(true, nil)
//    } else {
//        completionBlock(false, error)
//    }
//}
//task.resume()

