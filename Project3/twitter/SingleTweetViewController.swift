//
//  SingleTweetViewController.swift
//  twitter
//
//  Created by Iria on 10/29/16.
//  Copyright © 2016 Iria. All rights reserved.
//

import UIKit

class SingleTweetViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetText.text = tweet?.text
        
        let formattedTimestamp = formatTimestamp(timestamp: tweet?.timestamp)
        
        timestamp.text = "\(formattedTimestamp)"
        
        let user = tweet?.user
        
        name.text = user?.name
        username.text = "@\((user?.screenname)!)"
        
        profileImageView.setImageWith((user?.profileUrl)!)
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        setCount(type: "retweet")
        setCount(type: "favorite")

        toggleFavoriteIcon()
        toggleRetweetIcon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func formatTimestamp(timestamp: Date?) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter.string(from: timestamp!)
    }
    
    func setCount(type: String?)  {
        let countString = type == "retweet" ? "\((tweet?.retweetCount)!) RETWEETS" : "\((tweet?.favoriteCount)!) LIKES"
        
        let label = type == "retweet" ? retweetCount : favoriteCount
        
        label?.text = ("\(countString)")
    }
    
    func toggleFavoriteIcon() {
        if (tweet?.favorited)! {
            let favoriteImageView = favoriteButton.imageView
            
            favoriteImageView?.image = favoriteImageView?.image?.withRenderingMode(.alwaysTemplate)
            favoriteImageView?.tintColor = UIColor.red
        }
    }
    
    func toggleRetweetIcon()  {
        if (tweet?.retweeted)! {
            let retweetImageView = retweetButton.imageView
            
            retweetImageView?.image = retweetImageView?.image?.withRenderingMode(.alwaysTemplate)
            retweetImageView?.tintColor = UIColor.green
        }
    }

    @IBAction func onBackButton(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onReplyButton(_ sender: AnyObject) {
        let createTweetViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateTweetViewController") as? CreateTweetViewController
        
        createTweetViewController?.replyToId = tweet?.tweetId
        createTweetViewController?.replyToUsername = tweet?.user?.screenname
        
        navigationController?.pushViewController(createTweetViewController!, animated: true)
    }

    @IBAction func onRetweetButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.retweet(tweetId: (tweet?.tweetId)!, hasRetweeted: (tweet?.retweeted)!, success: { (tweet: Tweet) in
            
            self.tweet = tweet
            self.setCount(type: "retweet")
            self.toggleRetweetIcon()
            
        }, failure: nil)

    }
    
    @IBAction func onFavoriteButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.favoriteTweet(tweetId: (tweet?.tweetId)!, isFavorited: (tweet?.favorited)!, success: { (tweet: Tweet) in
            
            self.tweet = tweet
            self.setCount(type: "favorite")
            self.toggleFavoriteIcon()
            
        }, failure: nil)
    }
}
