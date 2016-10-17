//
//  MovieDetailsViewController.swift
//  MovieViewer
//
//  Created by Iria on 10/14/16.
//  Copyright © 2016 Iria. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movieData: NSDictionary?
    var movieImageUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        if movieImageUrl != nil {
            posterView.setImageWith(movieImageUrl!)
        }
        titleLabel.text = movieData?["title"] as? String
        overviewLabel.text = movieData?["overview"] as? String
        
        titleLabel.sizeToFit()
        overviewLabel.sizeToFit()
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
