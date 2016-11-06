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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
