//
//  ViewController.swift
//  MBTATrainETA
//
//  Created by MacOS on 4/3/16.
//  Copyright (c) 2016 MacOS. All rights reserved.
//

import UIKit

//Stack panel
//how to populate pickers

//TODO
//Tableview refresh
//Run it
//Async to SingleFile
class ViewController:
    UIViewController,
    //UITableViewController,
    UITableViewDataSource,
    UITableViewDelegate,  UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var table2: UITableView!

    var tableData: [String] = []
    var routes : [String: String] = [String: String]()
    var stations : [String: String] = [String: String]()
    var directions : [String] = ["Inbound", "Outbound"]
    var trips : [Trip] = []
    var selectedDirection : String = "Inbound"
    
    @IBOutlet weak var Picker3: UIPickerView!
    @IBOutlet weak var Picker2: UIPickerView!
    @IBOutlet weak var Picker1: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Picker1.dataSource = self
        Picker1.delegate = self
        Picker2.dataSource = self
        Picker2.delegate = self
        Picker3.dataSource = self
        Picker3.delegate = self
        table2.dataSource = self
        table2.delegate = self
        
        table2.rowHeight = 50
        loadRoutes()

    }

    func get_data_from_url(url:String, type:String, station:String)
    {
        let httpMethod = "GET"
        let timeout = 15
        let url = NSURL(string: url)
        let urlRequest = NSMutableURLRequest(URL: url!,
            cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 15.0)
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(
            urlRequest,
            queue: queue,
            completionHandler: {(response: NSURLResponse!,
                data: NSData!,
                error: NSError!) in
                if data.length > 0 && error == nil{
                    if (type == "route")
                    {
                        self.extract_json_lines(data!)
                    } else if (type == "station")
                    {
                        var direction = 0
                        if (self.selectedDirection == "Inbound")
                        {
                            direction = 0
                        }
                        else
                        {
                            direction = 1
                        }
                        
                        self.extract_json_stations(data!, direction: direction)
                    } else if (type == "eta")
                    {
                        var direction = 0
                        if (self.selectedDirection == "Inbound")
                        {
                            direction = 0
                        }
                        else
                        {
                            direction = 1
                        }
                        
                        self.extract_json_eta(data!, direction : direction, station: station)
                    }
                }else if data.length == 0 && error == nil{
                    println("Nothing was downloaded")
                } else if error != nil{
                    println("Error happened = \(error)")
                }
            }
        )
    }
    
    func extract_json_lines(jsonData:NSData)
    {
        var jsonDic : [String : String] = [String: String]()
        
        var parseError: NSError?
        let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &parseError) as NSDictionary
        if (parseError == nil)
        {
            if let mode = json.objectForKey("mode") as? NSArray
            {
                    for (var i = 0; i < mode.count; i++)
                    {
                        if let route = mode[i] as? NSDictionary
                        {
                            if let r = route.objectForKey("route") as? NSArray
                            {
                                for (var j = 0; j < r.count; j++)
                                {
                                    if let routeO = r[j] as? NSDictionary
                                    {
                                        var route_id = routeO.objectForKey("route_id") as String
                                        var route_name = routeO.objectForKey("route_name") as String
                                        jsonDic[route_name] = route_id
                                    }
                                }
                            }
                        }
                    }
                }
            
            /*
            if let countries_list = json as? NSArray
            {
                for (var i = 0; i < countries_list.count ; i++ )
                {
                    if let country_obj = countries_list[i] as? NSDictionary
                    {
                        if let country_name = country_obj["country"] as? String
                        {
                            if let country_code = country_obj["code"] as? String
                            {
                                TableData.append(country_name + " [" + country_code + "]")
                            }
                        }
                    }
                }
            }*/

            

        }
        self.routes = jsonDic
        Picker1.reloadAllComponents()

        //Picker1.selectRow(183, inComponent: 0, animated: true)
        //do_table_refresh();
    }
    
    func extract_json_eta(jsonData:NSData, direction:Int, station:String)
    {
        var tempTrips :[Trip] = []
        
        var parseError: NSError?
        let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &parseError) as NSDictionary
        if (parseError == nil)
        {
            if let mode = json.objectForKey("mode") as? NSArray
            {
                    if let routeDic = mode[0] as? NSDictionary
                    {
                        if let route = routeDic.objectForKey("route") as? NSArray
                        {
                            if let directionA = route[0].objectForKey("direction") as? NSArray
                            {
                                if let trip = directionA[direction].objectForKey("trip") as? NSArray
                                {
                                    for (var t = 0; t < trip.count; t++)
                                    {
                                        let tO = trip[t] as NSDictionary
                                        var trip_name = tO.objectForKey("trip_name") as String
                                        var trip_headsign = tO.objectForKey("trip_headsign") as String
                                        var time = tO.objectForKey("pre_dt") as String
                                        var tp = Trip(trip : trip_name, station : station, headsign : trip_headsign, time : time,  id : "")
                                        tempTrips.append(tp)
                                    }
                                }
                            }
                        }
                }
            }
        }
        self.trips = tempTrips
        
        self.tableData = []
        for ( var i = 0; i < self.trips.count; i++)
        {
            self.tableData.append(trips[i].GetContent())
        }
        dispatch_async(dispatch_get_main_queue(), {
        self.table2.reloadData()
        });
    }
    
    func extract_json_stations(jsonData:NSData, direction:Int)
    {
        var jsonDic : [String : String] = [String: String]()
        
        var parseError: NSError?
        let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &parseError) as NSDictionary
        if (parseError == nil)
        {
            if let directionArray = json.objectForKey("direction") as? NSArray
            {
                    if let route = directionArray[direction] as? NSDictionary
                    {
                        if let r = route.objectForKey("stop") as? NSArray
                        {
                            for (var j = 0; j < r.count; j++)
                            {
                                if let routeO = r[j] as? NSDictionary
                                {
                                    var route_id = routeO.objectForKey("parent_station") as String
                                    var route_name = routeO.objectForKey("parent_station_name") as String
                                    jsonDic[route_name] = route_id
                                }
                            }
                        }
                    }
            }
        }
        self.stations = jsonDic
        Picker3.reloadAllComponents()
        //do_table_refresh();
    }

    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = tableData[indexPath.row]
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == Picker1)
        {
            return routes.count
        }
        else if (pickerView == Picker2)
        {
            return directions.count
        }
        else if (pickerView == Picker3)
        {
            return stations.count
        } else
        {
            return 0
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if (pickerView == Picker1)
        {
            var s:[String] = [String] (routes.keys)
            return s[row]
            
        }
        else if (pickerView == Picker2)
        {
            return directions[row]
        } else if (pickerView == Picker3)
        {
            var s:[String] = [String](stations.keys)
            return s [row]
        } else
        {
            return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Do nothing for now
        if (pickerView == Picker1)
        {
            var routeName = [String](routes.keys)[row]
            var routeId = routes[routeName]
            
            var direction = self.selectedDirection
            
            loadStations(routeId!)
        }
        else if (pickerView == Picker2)
        {
            self.selectedDirection = directions[row]
            
            //Load stations alter
        } else if (pickerView == Picker3)
        {
            var stationKeys : [String] = [String] (stations.keys)
            var key : String = stationKeys[row]
            var station : String = stations[key] as String!
            loadETA(self.selectedDirection, station: station)
            
        } else
        {
            //Do nothing for now
            //reload table data
        }
    }
    
    func loadRoutes()
    {
        var routeUrl = GetServiceData().GetRouteUrl()
        get_data_from_url(routeUrl, type: "route", station: "")
        Picker1.reloadAllComponents()

    }
    
    func loadStations(route : String)
    {
        var stationUrl = GetServiceData().GetStationUrl(route)
        get_data_from_url(stationUrl, type: "station", station:"")
        Picker3.reloadAllComponents()
    }
    
    func loadETA(direction : String, station : String)
    {
        var predictionalUrl = GetServiceData().GetPredictionUrl(station)
        get_data_from_url(predictionalUrl, type: "eta", station: station)

    }
}

