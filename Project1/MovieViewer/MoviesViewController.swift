//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Iria on 10/12/16.
//  Copyright © 2016 Iria. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    var movie: NSDictionary?
    var movieImageUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(makeApiRequest(_:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        self.makeApiRequest(nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        self.movie = movies?[indexPath.row]
        let title = self.movie?["title"] as? String
        let overview = self.movie?["overview"] as? String
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        let posterPath = self.movie?["poster_path"] as? String
        
        self.movieImageUrl = URL(string: baseUrl + posterPath!)
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        cell.posterView.setImageWith(self.movieImageUrl!)

        return cell
    }
    
    func makeApiRequest(_ refreshControl: UIRefreshControl?) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        // Add progress spinner
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {

                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
                    
                    // Hide progress spinner
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    refreshControl?.endRefreshing()
                }
            }
        });
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as? MovieDetailsViewController

        destinationViewController?.movieData = self.movie
        destinationViewController?.movieImageUrl = self.movieImageUrl
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
