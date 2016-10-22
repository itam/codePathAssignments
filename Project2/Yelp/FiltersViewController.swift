//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Iria on 10/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String: AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    
    var categories: [[String: String]]!
    var switchStates = [Int: Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        categories = [
            ["name": "Afghan", "code": "afghani"],
            ["name": "African", "code": "african"],
            ["name": "American", "code": "newamerican"],
            ["name": "Afghan", "code": "afghani"],
            ["name": "African", "code": "african"],
            ["name": "American", "code": "newamerican"],
            ["name": "Afghan", "code": "afghani"],
            ["name": "African", "code": "african"],
            ["name": "American", "code": "newamerican"],
            ["name": "Afghan", "code": "afghani"],
            ["name": "African", "code": "african"],
            ["name": "American", "code": "newamerican"],
            ["name": "Afghan", "code": "afghani"],
            ["name": "African", "code": "african"],
            ["name": "American", "code": "newamerican"],
            ["name": "Afghan", "code": "afghani"],
            ["name": "African", "code": "african"],
            ["name": "American", "code": "newamerican"],
            ["name": "Afghan", "code": "afghani"],
            ["name": "African", "code": "african"],
            ["name": "American", "code": "newamerican"],
            ["name": "Afghan", "code": "afghani"],
            ["name": "African", "code": "african"],
            ["name": "American", "code": "newamerican"],
            ["name": "Afghan", "code": "afghani"],
            ["name": "African", "code": "african"],
            ["name": "American", "code": "newamerican"],
            ["name": "Afghan", "code": "afghani"],
            ["name": "African", "code": "african"],
            ["name": "American", "code": "newamerican"]
        ]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        
        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self
        
        cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
        
        return cell
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)
        
        switchStates[(indexPath?.row)!] = value
    }

    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true)
    }
    
    @IBAction func onSearchButton(_ sender: AnyObject) {
        dismiss(animated: true)
        
        var filters = [String: AnyObject]()
        var selectedCategories = [String]()
        
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject?
        }
        
        delegate?.filtersViewController!(filtersViewController: self, didUpdateFilters: filters)
    }
    
    

}
