//
//  SelectionCell.swift
//  Yelp
//
//  Created by Iria on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class SelectionCell: UITableViewCell {

    @IBOutlet weak var selectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
