//
//  TwitterClient.swift
//  twitter
//
//  Created by Iria on 10/28/16.
//  Copyright © 2016 Iria. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "03H01OeZduhArjGDxwK7w", consumerSecret: "ygATTwaAVh0GT7gnyYAmOnpfN5rF6siiY13dmOQYyWs")
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let userDictionary = response as? NSDictionary
            let user = User(dictionary: userDictionary!)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize() // Bug with BDB
        fetchRequestToken(withPath: "https://api.twitter.com/oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterapp://oauth") as URL!, scope: nil, success: { (credential: BDBOAuth1Credential?) -> Void in
            
            let urlString = "https://api.twitter.com/oauth/authorize?oauth_token=\((credential?.token)!)"
            
            let authorizeUrl = NSURL(string: urlString)! as URL
            
            UIApplication.shared.open(authorizeUrl)
            
        }, failure: { (error) in
            self.loginFailure?(error!)
            print("error: \(error?.localizedDescription)")
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: User.USER_DID_LOGOUT_NOTIFICATION, object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "https://api.twitter.com/oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                
                self.loginSuccess?()
                
            }, failure: { (error: Error) in
                    self.loginFailure?(error)
            })
            
        }, failure: { (error) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
        
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                let dictionaries = response as! [NSDictionary]
            
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
                success(tweets)
            
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
}
