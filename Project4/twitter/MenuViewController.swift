//
//  MenuViewController.swift
//  twitter
//
//  Created by Iria on 11/3/16.
//  Copyright © 2016 Iria. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewControllers: [UIViewController] = []
    var hamburgerViewController: HamburgerViewController!
    
    let menuTitles = ["Tweets", "Profile"]
    
    private var tweetsViewController: UIViewController!
    private var profileViewController: UIViewController!
    private var mentionsViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        tweetsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        
        viewControllers.append(tweetsViewController)
        viewControllers.append(profileViewController)
        
        hamburgerViewController.contentViewController = tweetsViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        cell.menuLabel.text = menuTitles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var newViewController = viewControllers[indexPath.row]
        
        hamburgerViewController.contentViewController = newViewController
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
