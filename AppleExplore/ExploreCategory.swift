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
    var popularApps : String?
    
    init(json: JSON) {
        
        self.id = json["id"].intValue
        self.categoryName = json["name"].stringValue
        self.popularApps = json["rssUrls"]["topFreeApplications"].stringValue
        // parsing key-value to array based explore categories
        if let subCategories = json["subgenres"].dictionary {
            self.exploreCategories = [ExploreCategory]()
            for genre in subCategories {
                let categoryObtained = ExploreCategory(json: genre.1)
                exploreCategories?.append(categoryObtained)
            }
            
            // sort by name as done in explore section in appstore app
            self.exploreCategories?.sortInPlace({ (elementOne, elementTwo) -> Bool in
                let stringOne = elementOne.categoryName
                let stringTwo = elementTwo.categoryName
                return (stringOne!.compare(stringTwo!) == NSComparisonResult.OrderedAscending)

            })
         
        }
        
    }
    
    
}


