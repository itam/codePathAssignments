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
            print("error in login")
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        
        requestSerializer.removeAccessToken()
        deauthorize()
        
        NotificationCenter.default.post(name: User.USER_DID_LOGOUT_NOTIFICATION, object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "https://api.twitter.com/oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            self.requestSerializer.saveAccessToken(accessToken);
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                
                self.loginSuccess?()
                
            }, failure: { (error: Error) in
                print("handle open url failed")
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
                print("error in homeTimeline")
                failure(error)
        })
    }
    
    func createTweet(tweet: String?, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let parameters = [
            "status": tweet!
        ]
        
        post("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            print("error creating tweet: \(error.localizedDescription)")
            failure(error)
        }
    }
    
    func replyToTweet() {
    
    }
    
    func retweet(tweetId: String, hasRetweeted: Bool, success: ((Tweet) -> ())?, failure: ((Error) -> ())?) {
        
        let endpoint: String = hasRetweeted ? "unretweet" : "retweet"
        let retweetUrl = "1.1/statuses/\(endpoint)/\(tweetId).json"
        let parameters = [
            "id": tweetId
        ]
        
        post(retweetUrl, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            print("\(endpoint) successful")
            success?(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            print("error retweeting: \(error.localizedDescription)")
            failure?(error)
        }
    
    }
    
    func favoriteTweet(tweetId: String, isFavorited: Bool, success: ((Tweet) -> ())?, failure: ((Error) -> ())?) {
        
        let endpoint: String = isFavorited ? "destroy" : "create"
        let parameters = [
            "id": tweetId
        ]
        
        post("1.1/favorites/\(endpoint).json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            print("\(endpoint) successful")
            success?(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            print("error favoriting: \(error.localizedDescription)")
            failure?(error)
        }
    }
}
