//
//  ExploreAppInfo.swift
//  AppleExplore
//
//  Created by kuliza-195 on 28/08/16.
//  Copyright © 2016 Chandra. All rights reserved.
//

import Foundation
import SwiftyJSON

class ExploreAppInfo {
    
    var appName : String?
    var appOwner : String?
    var appImageUrl : NSURL?
    
    init(json: JSON) {
        
        self.appName = json["im:name"]["label"].string
        self.appOwner = json["im:artist"]["label"].stringValue
        
        if let imageArray = json["im:image"].array {
            if imageArray.count > 0 {
                if let urlObtained = imageArray[2]["label"].string {
                    self.appImageUrl = NSURL(string: urlObtained)
                }
            }
            
        }
    
        
    }
    
    
}