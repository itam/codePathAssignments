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

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, SelectionCellDelegate {
    
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
    var selectedDistanceCell: SelectionCell?
    var selectedSortByCell: SelectionCell?
    var distanceStates = [Int: Bool]()
    var sortByStates = [Int: Bool]()
    
    var filters: Filters = Filters()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
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
                print("distance")
                print(distanceStates)
                
            
                selectedDistanceCell?.accessoryType = .none
                
                filters.distance = distance[(indexPath.row)]["value"] as? NSNumber
                
                selectedDistanceCell = tableView.cellForRow(at: indexPath) as? SelectionCell
                selectedDistanceCell?.accessoryType = .checkmark
            case 2:
                print("sortby")
                print(sortByStates)
                
                selectedSortByCell?.accessoryType = .none
                
                filters.sortBy = YelpSortMode(rawValue: (sortBy[(indexPath.row)]["value"] as? Int)!)
                
                selectedSortByCell = tableView.cellForRow(at: indexPath) as? SelectionCell
                selectedSortByCell?.accessoryType = .checkmark
            default:
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
            cell.isChosen = distanceStates[indexPath.row] ?? false
            cell.isSelected = distanceStates[indexPath.row] ?? false
            
            cell.delegate = self
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SortBySelectionCell", for: indexPath) as! SelectionCell
            
            cell.selectionLabel.text = sortBy[indexPath.row]["name"]! as? String
            cell.isChosen = sortByStates[indexPath.row] ?? false
            cell.isSelected = sortByStates[indexPath.row] ?? false
            cell.delegate = self
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            
            cell.delegate = self
            
            cell.switchLabel.text = categories[indexPath.row]["name"]! as String
            cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
            
            return cell
        }
    }
    
    func selectionCell(selectionCell: SelectionCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: selectionCell)
        
        let section = indexPath?.section
        
        if section == 1 {
            print("reset")
            // Reset selected state because we can only have one selected at a time
//            for (row, _) in distanceStates {
//                distanceStates[row] = false
//            }
            
//            distanceStates[(indexPath?.row)!] = value
            
            
            
            selectionCell.isChosen = value
            
            print(filters.distance)
        } else if section == 2 {
//            for (row, _) in distanceStates {
//                distanceStates[row] = false
//            }
            
//            sortByStates[(indexPath?.row)!] = value
            selectionCell.isChosen = value
            
            print("is Chosen : \(selectionCell.isChosen)")
            
            print("sort by: \(filters.sortBy)")
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
