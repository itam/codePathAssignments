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
    
    var user: User! {
        didSet {
            print("set user")
            
            view.layoutIfNeeded()
            
            if user.profileBackgroundUrl != nil {
                profileBackgroundImageView.setImageWith(user.profileBackgroundUrl!)
            }
            
            profileImageView.setImageWith(user.profileUrl!)
            
            nameLabel.text = user.name
            usernameLabel.text = user.screenname
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
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
