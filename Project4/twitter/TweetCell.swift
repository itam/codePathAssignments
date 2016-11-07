//
//  TweetCell.swift
//  twitter
//
//  Created by Iria on 10/29/16.
//  Copyright © 2016 Iria. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet? {
        didSet {
            tweetText.text = tweet?.text
            
            let formattedTimestamp = formatTimestamp(timestamp: tweet?.timestamp)
            
            timestamp.text = "· \(formattedTimestamp)"
            
            let user = tweet?.user
            
            name.text = user?.name
            username.text = "@\((user?.screenname)!)"
            
            profileImageView.setImageWith((user?.profileUrl)!)
            profileImageView.layer.cornerRadius = 5
            profileImageView.clipsToBounds = true
        }
    }
    
    func formatTimestamp(timestamp: Date?) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter.string(from: timestamp!)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onReplyButton(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let createTweetViewController = storyboard.instantiateViewController(withIdentifier: "CreateTweetViewController") as? CreateTweetViewController
        
        createTweetViewController?.replyToId = tweet?.tweetId
        createTweetViewController?.replyToUsername = tweet?.user?.screenname
        
//        navigationController?.pushViewController(createTweetViewController!, animated: true)
    }
    
    @IBAction func onRetweetButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.retweet(tweetId: (tweet?.tweetId)!, hasRetweeted: (tweet?.retweeted)!, success: { (tweet: Tweet) in
        
            self.toggleRetweetIcon()
            
        }, failure: nil)
    }

    @IBAction func onFavoriteButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.favoriteTweet(tweetId: (tweet?.tweetId)!, isFavorited: (tweet?.favorited)!, success: { (tweet: Tweet) in
            
            self.tweet = tweet
            self.toggleFavoriteIcon()
            
            }, failure: nil)
    }
    
}
