//
//  ExploreCategory.swift
//  AppleExplore
//
//  Created by kuliza-195 on 27/08/16.
//  Copyright © 2016 Chandra. All rights reserved.
//

import Foundation
import SwiftyJSON

class ExploreCategory {
    
    var categoryName : String?
    var id : Int?
    var exploreCategories : [ExploreCategory]?
    
    init(json: JSON) {
        
        self.id = json["id"].intValue
        self.categoryName = json["name"].stringValue
        
        // parsing key-value to array based explore categories
        if let subCategories = json["subgenres"].dictionary {
            self.exploreCategories = [ExploreCategory]()
            for genre in subCategories {
                let categoryObtained = ExploreCategory(json: genre.1)
                exploreCategories?.append(categoryObtained)
            }
        }
        
    }
    
    
}


