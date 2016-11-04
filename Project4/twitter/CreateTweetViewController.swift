//
//  CreateTweetViewController.swift
//  twitter
//
//  Created by Iria on 10/30/16.
//  Copyright © 2016 Iria. All rights reserved.
//

import UIKit

class CreateTweetViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    
    var replyToId: String?
    var replyToUsername: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextView.layer.borderColor = UIColor.lightGray.cgColor
        tweetTextView.layer.borderWidth = 1
        
        // Prevent text edit from starting in the middle of the text view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        if let username = replyToUsername {
            tweetTextView.text = "@\(username) "
        }
        
//        tweetTextView.text = "What's happening?"
//        tweetTextView.textColor = UIColor.gray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweetButton(_ sender: AnyObject) {
        let tweet = tweetTextView.text!
        
        TwitterClient.sharedInstance?.createTweet(tweet: tweet, replyToId: replyToId, success: { (tweet: Tweet) in
            
            self.navigationController?.popViewController(animated: true)
        
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
    }

    @IBAction func onBackButton(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
}
