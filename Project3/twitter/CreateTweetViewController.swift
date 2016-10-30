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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tweetTextView.text = "What's happening?"
//        tweetTextView.textColor = UIColor.gray

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweetButton(_ sender: AnyObject) {
        let tweet = tweetTextView.text!
        
        TwitterClient.sharedInstance?.createTweet(tweet: tweet, success: { (tweet: Tweet) in
            self.navigationController?.popViewController(animated: true)
        
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
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
