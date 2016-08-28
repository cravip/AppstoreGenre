//
//  Api.swift
//  AppleExplore
//
//  Created by kuliza-195 on 27/08/16.
//  Copyright © 2016 Chandra. All rights reserved.
//

import Foundation
import Alamofire

public class API {
    
    // base url
    public static let baseUrl: String = "https://itunes.apple.com"
    
    // urls
    private static let categoryUrl : String = "/WebObjects/MZStoreServices.woa/ws/genres?id=36"
    
    
    public enum Endpoints {
        
        case ExploreCategories()
        case ExploreAppInfo (String)
        
        public var method: Alamofire.Method {
            switch self {
            case .ExploreCategories, .ExploreAppInfo :
                return Alamofire.Method.GET
            
                
            }
        }
        
        
        public var path: String {
            switch self {
            case .ExploreCategories:
                return baseUrl + categoryUrl
                
            case .ExploreAppInfo(let pathObtained) :
                return pathObtained
            }
        }
        
        
        public var parameters: [String : AnyObject]? {
            
            var parameters = [String : AnyObject]()
            switch self {
            case .ExploreCategories, .ExploreAppInfo :
                return nil
            
            return parameters
            
            
            }
        }
        
        
        public var headers:[String:String]?{
            var headers = [String:String]()
            headers["Content-Type"] = "application/json"
            
            return headers
        }
        
    }
    
    public static func request(endpoint: API.Endpoints,completionHandler: Response<AnyObject, NSError> -> Void) -> Request {
        print(endpoint.path)
        let request =   Alamofire.Manager.sharedInstance.request(
            endpoint.method,
            endpoint.path,
            parameters: endpoint.parameters,
            encoding: .JSON,
            headers: endpoint.headers
            ).responseJSON { response in
                if (response.result.error) != nil {
                    completionHandler(response)
                } else {
                    completionHandler(response)
                }
        }
        return request
    }
}
