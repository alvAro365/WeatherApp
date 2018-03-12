//
//  City.swift
//  WeatherApp
//
//  Created by Alvar Aronija on 12/03/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

import Foundation

struct City {
//    enum Weather: String {
//        case forecast, temperature, wind
//    }
    
    let name: String
    let temperature: Any?
    
}

extension City {
    init?(json: [String : Any]) {
        guard let name = json["name"] as? String,
            let temperatureJSON = json["main"] as? [String: Any],
            let temperature = temperatureJSON["temp"],
            let windJSON = json["wind"] as? [String: Any],
            let wind = windJSON["speed"]
        else {
                return nil
        }
        self.name = name
        self.temperature = temperature
    }
}

extension City {
    
    static func cities(matching query: String, completion: ([City]) -> Void) {
        var searchURLComponents = URLComponents.init(string: "http://api.openweathermap.org")
        searchURLComponents?.path = "/data/2.5/weather"
        let queryItemQuery = URLQueryItem(name: "q", value: query)
        let queryItemType = URLQueryItem(name: "type", value: "like")
        let queryItemUnits = URLQueryItem(name:"units", value: "metric")
        let queryItemAppId = URLQueryItem(name:"appid", value: "d8b585f530bf87bf33de4f4939f30f63")
        searchURLComponents?.queryItems = [queryItemQuery, queryItemType, queryItemUnits, queryItemAppId]

        let searchURL = searchURLComponents?.url!
        print(searchURL as Any!)
        
        let task = URLSession.shared.dataTask(with: searchURL!, completionHandler: { (data, _, _) in
            var cities: [City] = []
            
            if let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject {
                print(json)
            }
        
        })
        task.resume()
    }
}



