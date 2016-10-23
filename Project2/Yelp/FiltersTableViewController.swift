//
//  FiltersTableViewController.swift
//  Yelp
//
//  Created by Iria on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersTableViewControllerDelegate {
    @objc optional func filtersTableViewController(filtersTableViewController: FiltersTableViewController, didUpdateFilters filters: Filters)
}

class FiltersTableViewController: UITableViewController {

    @IBOutlet weak var dealsSwitch: UISwitch!
    
    @IBOutlet weak var categorySwitch1: UISwitch!
    @IBOutlet weak var categorySwitch2: UISwitch!
    @IBOutlet weak var categorySwitch3: UISwitch!
    @IBOutlet weak var categorySwitch4: UISwitch!
    
    @IBOutlet weak var selectionCell: UITableViewCell!
    
    weak var delegate: FiltersTableViewControllerDelegate?
    
    let categories = [
        ["name": "Afghan", "code": "afghani"],
        ["name": "African", "code": "african"],
        ["name": "American, New American", "code": "newamerican"],
        ["name": "American, Tradtional", "code": "tradamerican"]
    ]
    
    var filters: Filters = Filters () {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSwitches()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSwitches() {
        dealsSwitch.isOn = false
        
        selectionCell.accessoryType = .checkmark
        
        categorySwitch1.isOn = false
        categorySwitch2.isOn = false
        categorySwitch3.isOn = false
        categorySwitch4.isOn = false
    }

    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true)
    }
    
    @IBAction func onSaveButton(_ sender: AnyObject) {
        dismiss(animated: true)
        
        var selectedCategories = [String]()
        
        filters.deals = dealsSwitch.isOn
        
        if categorySwitch1.isOn {
            selectedCategories.append("afghani")
        }
        
        if categorySwitch2.isOn {
            selectedCategories.append("african")
        }
        
        if categorySwitch3.isOn {
            selectedCategories.append("newamerican")
        }
        
        if categorySwitch4.isOn {
            selectedCategories.append("tradamerican")
        }
        
        filters.categories = selectedCategories
        
        delegate?.filtersTableViewController!(filtersTableViewController: self, didUpdateFilters: filters)
    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath)
//        
//        print("tapped")
//
//        // Configure the cell...
//
//        return cell
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
