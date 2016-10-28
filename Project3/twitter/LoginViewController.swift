//
//  LoginViewController.swift
//  twitter
//
//  Created by Iria on 10/27/16.
//  Copyright © 2016 Iria. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: AnyObject) {
        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "03H01OeZduhArjGDxwK7w", consumerSecret: "ygATTwaAVh0GT7gnyYAmOnpfN5rF6siiY13dmOQYyWs")
        
        twitterClient?.deauthorize() // Bug with BDB
        twitterClient?.fetchRequestToken(withPath: "https://api.twitter.com/oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterapp://oauth") as URL!, scope: nil, success: { (credential: BDBOAuth1Credential?) -> Void in
                print("Token!")
            
            let urlString = "https://api.twitter.com/oauth/authorize?oauth_token=\((credential?.token)!)"
            
            let authorizeUrl = NSURL(string: urlString)! as URL
            
            UIApplication.shared.open(authorizeUrl)
            
            
            }, failure: { (error) in
                print("error: \(error?.localizedDescription)")
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
