//
//  TweetsViewController.swift
//  twitter
//
//  Created by Iria on 10/29/16.
//  Copyright © 2016 Iria. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var endpoint: String? = "home"
    
    var tweets: [Tweet]?
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Dynamic cell height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // Check if we actually need new tweets, otherwise we hit the rate limit REALLY quickly.
        if tweets == nil {
            setTimeline()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as? TweetCell
        
        cell?.tweet = tweets?[indexPath.row]
        
        // Add ability to tap profile image to launch full profile
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage(sender:)))
        
        cell?.profileImageView.isUserInteractionEnabled = true
        cell?.profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        return cell!
    }
    
    func setTimeline() {
        TwitterClient.sharedInstance?.getTimeline(type: endpoint!, parameters: nil, success: { (tweets: [Tweet]) in
            print("setting \((self.endpoint)!) tweets")
                self.tweets = tweets
                self.tableView.reloadData()
            }, failure: { (error: Error) in
                print("error loading timeline: \(error.localizedDescription)")
        })
    }
    
    func didTapProfileImage(sender: UITapGestureRecognizer) {

        self.performSegue(withIdentifier: "profileSegue", sender: sender)
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        setTimeline()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "singleTweetSegue" {
            let destinationViewController = segue.destination as? SingleTweetViewController
            
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPath(for: cell)
            let tweet = tweets?[(indexPath?.row)!]
            
            destinationViewController?.tweet = tweet
            
            self.tableView.deselectRow(at: indexPath!, animated:true)
        } else if segue.identifier == "profileSegue" {
            let gestureRecognizer = sender as! UITapGestureRecognizer
            
            let locationInView = gestureRecognizer.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: locationInView) {
                let destinationViewController = segue.destination as? ProfileViewController
                destinationViewController?.user = tweets![indexPath.row].user!
            }
        }
    }
    
    @IBAction func onLogoutButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
    }
}
