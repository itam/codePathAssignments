//
//  Filters.swift
//  Yelp
//
//  Created by Iria on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class Filters: NSObject {
    var deals: Bool? = false
    var distance: NSNumber? = 5
    var sortBy: YelpSortMode? = YelpSortMode(rawValue: 0)
    var categories: [String]? = []
}
