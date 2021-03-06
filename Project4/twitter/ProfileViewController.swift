//
//  ProfileViewController.swift
//  twitter
//
//  Created by Iria on 11/4/16.
//  Copyright © 2016 Iria. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileBackgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var tweetsTableView: UIView!
    
    var tweetsViewController: TweetsViewController!
    
    var user: User! {
        didSet {
            view.layoutIfNeeded()
            
            if user.profileBackgroundUrl != nil {
                profileBackgroundImageView.setImageWith(user.profileBackgroundUrl!)
                profileBackgroundImageView.contentMode = UIViewContentMode.scaleAspectFill
                profileBackgroundImageView.clipsToBounds = true
            }
            
            profileImageView.setImageWith(user.profileUrl!)
            
            // Style the profile image
            profileImageView.layer.cornerRadius = 5
            profileImageView.clipsToBounds = true
            profileImageView.layer.borderWidth = 5
            profileImageView.layer.borderColor = UIColor.white.cgColor
            
            nameLabel.text = user.name
            usernameLabel.text = "@\((user.screenname)!)"
            descriptionLabel.text = user.tagline
            tweetCountLabel.text = "\((user.tweetCount)!) TWEETS"
            followingCountLabel.text = "\((user.followingCount)!) FOLLOWING"
            followerCountLabel.text = "\((user.followerCount)!) FOLLOWERS"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil {
            user = User.currentUser
            
            navigationController?.isNavigationBarHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        tweetsViewController = storyboard?.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
        
        TwitterClient.sharedInstance?.userTimeline(screenname: user.screenname!, success: { (tweets: [Tweet]) in
            print("set user tweets")
            self.tweetsViewController.tweets = tweets
            
            self.tweetsViewController.willMove(toParentViewController: self)
            self.tweetsTableView.addSubview(self.tweetsViewController.view)
            self.tweetsViewController.didMove(toParentViewController: self)
            
            }, failure: { (error: Error) in
                print("error: \(error.localizedDescription)")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButton(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
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
