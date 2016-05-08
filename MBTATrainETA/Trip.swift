//
//  Trip.swift
//  MBTATrainETA
//
//  Created by MacOS on 4/14/16.
//  Copyright (c) 2016 MacOS. All rights reserved.
//

import Foundation

class Trip {
    var trip : String
    var headsign : String
    var time : Double
    var id : String
    var station : String
    
    init (trip: String, station: String, headsign: String, time: String, id: String)
    {
        self.trip = trip
        self.headsign = headsign
        self.time = (time as NSString).doubleValue
        self.id = id
        self.station = station
    }
    
    func GetTimeLeft() -> Int
    {
        return 1
    }
    
    func GetDepartureTime() -> String
    {
        let sf = NSDateFormatter()
        sf.dateFormat = "h:mm a"
        let d = NSDate(timeIntervalSince1970: time)
        let dateObj = sf.stringFromDate(d)
        return "DepartureTime: " + dateObj
    }
    
    func GetContent() -> String
    {
        let sf = NSDateFormatter()
        sf.dateFormat = "h:mm a"
        let d = NSDate(timeIntervalSince1970: time)
        let dateObj = sf.stringFromDate(d)
        let content = "Train Direction:" + headsign + " " + "Departure time: " + dateObj + "   "
        return content
    }
    
    
}