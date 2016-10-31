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

    @IBAction func onBackButton(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onReplyButton(_ sender: AnyObject) {
        
    }

    @IBAction func onRetweetButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.retweet(tweetId: (tweet?.tweetId)!, hasRetweeted: (tweet?.retweeted)!, success: nil, failure: nil)
    }
    
    @IBAction func onFavoriteButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.favoriteTweet(tweetId: (tweet?.tweetId)!, isFavorited: (tweet?.favorited)!, success: { (tweet: Tweet) in
            print("fave successful")
            self.tweet = tweet
            
        }, failure: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
