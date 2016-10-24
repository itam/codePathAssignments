//
//  SelectionCell.swift
//  Yelp
//
//  Created by Iria on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SelectionCellDelegate {
    @objc optional func selectionCell(selectionCell: SelectionCell, didChangeValue value: Bool)
}

class SelectionCell: UITableViewCell {

    @IBOutlet weak var selectionLabel: UILabel!
    
    weak var delegate: SelectionCellDelegate?
    
    var isChosen: Bool! = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        print("set selected \(self.selectionLabel.text)")
//        
//        isChosen = !isChosen
//        
//        selectionValueChanged()
//        
//        if isChosen == true {
//            self.accessoryType = .checkmark
//        } else {
//            self.accessoryType = .none
//        }
    }
    
    func selectionValueChanged() {
        delegate?.selectionCell!(selectionCell: self, didChangeValue: isChosen)
    }

}
