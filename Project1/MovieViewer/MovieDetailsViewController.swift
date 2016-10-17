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
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var movieData: NSDictionary?
    var movieImageUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height - 100)
        
        if movieImageUrl != nil {
            let urlRequest = URLRequest(url: movieImageUrl!)
            
            // Used to create fading effect, otherwise would use `setImageWith(url)`
            posterView.setImageWith(urlRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) in
                
                if imageResponse != nil {
                    self.posterView.alpha = 0.0
                    self.posterView.image = image
                    
                    UIView.animate(withDuration: 0.3, animations: { () in
                        self.posterView.alpha = 1.0
                    })
                } else {
                    self.posterView.image = image
                }
                
                }, failure: { (imageRequest, imageResponse, error) in
                    print("Error setting image: \(error)")
            })
        }
        titleLabel.text = movieData?["title"] as? String
        overviewLabel.text = movieData?["overview"] as? String
        releaseDateLabel.text = movieData?["release_date"] as? String
        
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
