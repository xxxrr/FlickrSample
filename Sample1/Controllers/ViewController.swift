//
//  ViewController.swift
//  Sample1
//
//  Created by Roopa Raman on 26/1/17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var flickrLoginView : UIWebView?
    @IBOutlet weak var progressingView : UIView?
    var tokenSecret : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async(execute: {
            self.progressingView?.isHidden = false
        })
        // Do any additional setup after loading the view, typically from a nib.
         DispatchQueue.global(qos: .default).async { [weak self] in
                let loginServiceManager = LoginService()
                loginServiceManager.getRequestToken { (response) in
                    DispatchQueue.main.async(execute: {
                        self!.progressingView?.isHidden = true
                    })
                    self!.flickrLoginView?.delegate = self
                    let oAuthTokenSecret = response["oauth_token_secret"]
                    self!.tokenSecret = oAuthTokenSecret!
                    let oAuthToken = response["oauth_token"]
                    let oAuthCallbackConfirmed = response["oauth_callback_confirmed"]
                    let flickrUrl = "https://www.flickr.com/services/oauth/authorize?oauth_token=" + oAuthToken!
                    let url = URL(string: flickrUrl)
                    let reqObj = URLRequest(url: url!)
                    self!.flickrLoginView?.loadRequest(reqObj)
                    
                }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }


}

extension ViewController : UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("started load")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("finish load")
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("failed load")
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("should start load")
        print(request.url ?? "")
        if(request.url?.absoluteString.hasPrefix("http://localhost"))!{
            let components = NSURLComponents(url: request.url!, resolvingAgainstBaseURL: false)
            var oAuthVerifier: String?
            var oAuthToken: String?
            if let queryItems = components?.queryItems{
                for queryItem in queryItems{
                    if(queryItem.name.lowercased() == "oauth_verifier"){
                        oAuthVerifier = queryItem.value!
                    }else if (queryItem.name.lowercased() == "oauth_token"){
                        oAuthToken = queryItem.value!
                    }
                }
            }
            print(oAuthVerifier!)
            print(oAuthToken!)
            
            if let recievedCode = oAuthVerifier {
                let loginServiceManager = LoginService()
                
                loginServiceManager.getAccessToken(oAuthToken: oAuthToken!, oAuthVerifier: oAuthVerifier!, oAuthTokenSecret: tokenSecret,success: { (response) in
                   
                    let oAuthTokenSecret = response["oauth_token_secret"]
                    let oAuthToken = response["oauth_token"]
                    let NSID = response["user_nsid"]
                    let fullName = response["fullname"]

                    UserDefaults.standard.set(oAuthToken, forKey: "oAuthToken")
                    UserDefaults.standard.set(oAuthTokenSecret, forKey: "oAuthTokenSecret")
                    UserDefaults.standard.set(NSID, forKey: "NSID")
                    
                    self.performSegue(withIdentifier: "loginSuccess", sender: nil)
                })
            }
            return false
        }else{
            return true
        }
    }
}
