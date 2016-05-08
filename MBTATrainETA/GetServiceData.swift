//
//  GetServiceData.swift
//  MBTATrainETA
	//
//  Created by MacOS on 4/5/16.
//  Copyright (c) 2016 MacOS. All rights reserved.
//

import Foundation

//typealias ServiceResponse = (JSON, NSError?) -> Void

class GetServiceData
{
    var apiKey = "r_vbkgrZEEOJwKgosF-xDg";

    func someFund() -> Bool {
        return true;
    }
    
    func GetRouteUrl() -> String {
        let url =  "http://realtime.mbta.com/developer/api/v2/routes?api_key=" + apiKey + "&format=json"
        return url
    }
    
    func GetStationUrl(route:String) -> String {
        let url = "http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=" + apiKey + "&route=" + route
        return url
    }
    
    func GetPredictionUrl(station:String) -> String {
        let url = "http://realtime.mbta.com/developer/api/v2/predictionsbystop?api_key=" + apiKey + "&stop=" + station  + "&format=json"
        return url
    }
    
    func GetRoutes() -> [String:String] {
        var routes : [String:String] = [String:String]()
        return routes
    }
    
    func GetStations(line : String) -> [String:String] {
        var stations : [String:String]  = [String:String]()
        return stations
        
        
        /*
        var names = [String] ()

        if let blogs = json["blogs"] as? [[String: AnyObject]] {
        for blog in blogs {
            if let name = blog["name"] as? String {
               names.append(name)
                    }
                }
            }
        */
    }
    
    func GetETA(station: String, direction: String) -> [Trip]
    {
        var trip : [Trip] = [Trip]()
        return trip
    }
    /*
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request  = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in let json:JSON = JSON(data:data)
            onCompletion(json, error)
        })
        task.resume()
    }*/
    }

    
