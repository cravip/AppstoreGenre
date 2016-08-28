//
//  CategoryFetcher.swift
//  AppleExplore
//
//  Created by kuliza-195 on 27/08/16.
//  Copyright © 2016 Chandra. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CategoryFetcher {
 
    static func getCategory(keywords: [String:String]?, completion:(result: ExploreCategory?, error: NSError?) -> Void) {
        API.request(.ExploreCategories()) { (response) in
            if (response.result.error) != nil {
                completion(result:nil, error: response.result.error)
            } else {
                if let json = response.result.value  {
                    let keyValue = JSON(json).dictionary
                    
                    // parse keyvalue and fetch first object as explorecategory
                    for key in keyValue! {
                        let category = ExploreCategory.init(json: key.1)
                        completion(result: category, error: nil)
                        return
                    }
                } else {
                    completion(result:nil, error: NSError(domain: "Data", code: 0, userInfo: [NSLocalizedDescriptionKey:"Parsing Error"]))
                }
            }
            
        }
        
    }
    
    static func getAppsInfo(keywords: String, completion:(result: [ExploreAppInfo]?, error: NSError?) -> Void) {
        API.request(.ExploreAppInfo(keywords)) { (response) in
            if (response.result.error) != nil {
                completion(result:nil, error: response.result.error)
            } else {
                if let json = response.result.value  {
                    let jsonObtained = JSON(json)
                    
                    
                    // parse array of app info data
                    var appInfoArray = [ExploreAppInfo]()
                    
                    if let appsData = jsonObtained["feed"]["entry"].array {
                        for app in appsData {
                            let appInfo = ExploreAppInfo.init(json: app)
                            appInfoArray.append(appInfo)
                        }
                    }
                    
                    completion(result:  appInfoArray, error:  nil)
                    return
                } else {
                    completion(result:nil, error: NSError(domain: "Data", code: 0, userInfo: [NSLocalizedDescriptionKey:"Parsing Error"]))
                }
            }
            
        }
        
    }
}