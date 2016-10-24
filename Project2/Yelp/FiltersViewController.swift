//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Iria on 10/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: Filters)
}

enum FiltersCategoryIdentifier: String {
    case OfferingADeal = "Offering a Deal"
    case Distance = "Distance"
    case SortyBy = "Sort By"
    case Categories = "Categories"
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    
    let sortBy = [
        ["name": "Best Match", "value": 0],
        ["name": "Distance", "value": 1],
        ["name": "Highest Rated", "value": 2]
    ]
    
    // Distance in meters
    let distance = [
        ["name": "Within 4 Blocks", "value": 482],
        ["name": "Walking (1 mi.)", "value": 1609],
        ["name": "Biking (2 mi.)", "value": 3218],
        ["name": "Driving (5 mi.)", "value": 8046],
    ]
    
    let categories = [
        ["name": "Afghan", "code": "afghani"],
        ["name": "African", "code": "african"],
        ["name": "American, New American", "code": "newamerican"],
        ["name": "American, Tradtional", "code": "tradamerican"]
    ]
    
    var switchStates = [Int: Bool]()
    var selectedDistanceCell: SelectionCell? // Current selected distance filter
    var selectedSortByCell: SelectionCell? // Current selected sort filter
    var distanceStates = [Int: Bool]()
    var sortByStates = [Int: Bool]()
    
    var filters: Filters = Filters()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.barTintColor = UIColor.red
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white

        let navBarAppearance = UINavigationBar.appearance()
        
        navBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch (section) {
            case 1:
                return FiltersCategoryIdentifier.Distance.rawValue
            case 2:
                return FiltersCategoryIdentifier.SortyBy.rawValue
            case 3:
                return FiltersCategoryIdentifier.Categories.rawValue
            default:
                return " "
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (section) {
            case 1:
                return distance.count
            case 2:
                return sortBy.count
            case 3:
                return categories.count
            default:
                return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.section) {
            case 1:
                // Deselect the option the user has already picked
                selectedDistanceCell?.accessoryType = .none
                
                // Update the filter model with the new selection
                filters.distance = distance[(indexPath.row)]["value"] as? NSNumber
                
                // Assign the newly selected option and show checkmark
                selectedDistanceCell = tableView.cellForRow(at: indexPath) as? SelectionCell
                selectedDistanceCell?.accessoryType = .checkmark
            case 2:
                // Deselect the option the user has already picked
                selectedSortByCell?.accessoryType = .none
                
                // Update the filter model with the new selection
                filters.sortBy = YelpSortMode(rawValue: (sortBy[(indexPath.row)]["value"] as? Int)!)
                
                // Assign the newly selected option and show checkmark
                selectedSortByCell = tableView.cellForRow(at: indexPath) as? SelectionCell
                selectedSortByCell?.accessoryType = .checkmark
            default:
                // Don't do anything if it is a switch cell
                print("default")
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            
            cell.switchLabel.text = FiltersCategoryIdentifier.OfferingADeal.rawValue
            cell.delegate = self
            
            cell.onSwitch.isOn = filters.deals ?? false
            
            return cell
        } else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceSelectionCell", for: indexPath) as! SelectionCell

            cell.selectionLabel.text = distance[indexPath.row]["name"] as? String
            cell.isSelected = distanceStates[indexPath.row] ?? false

            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SortBySelectionCell", for: indexPath) as! SelectionCell
            
            cell.selectionLabel.text = sortBy[indexPath.row]["name"]! as? String
            cell.isSelected = sortByStates[indexPath.row] ?? false
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            
            cell.delegate = self
            
            cell.switchLabel.text = categories[indexPath.row]["name"]! as String
            cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
            
            return cell
        }
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)
        
        if indexPath?.section == 3 {
            switchStates[(indexPath?.row)!] = value
        } else {
            filters.deals = value
        }
    }

    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true)
    }
    
    @IBAction func onSearchButton(_ sender: AnyObject) {
        dismiss(animated: true)
        
        var selectedCategories = [String]()
        
        // Build the categories array for searching
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters.categories = selectedCategories as [String]
        }
        
        delegate?.filtersViewController!(filtersViewController: self, didUpdateFilters: filters)
    }
    
    

}
