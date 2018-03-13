//
//  City.swift
//  WeatherApp
//
//  Created by Alvar Aronija on 12/03/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

import Foundation

struct City {
    let name: String
}

extension City {
    init?(json: [String : Any]) {
        guard let name = json["name"] as? String
//            let temperatureJSON = json["main"] as? [String: Any],
//            let temperature = temperatureJSON["temp"],
//            let windJSON = json["wind"] as? [String: Any],
//            let wind = windJSON["speed"]
        else {
                return nil
        }
        self.name = name
        print("The name of the city is \(self.name)")
    }
}

extension City {
    
    static func cities(matching query: String, completion: @escaping ([City]) -> Void) {
        var searchURLComponents = URLComponents.init(string: "http://api.openweathermap.org")
        searchURLComponents?.path = "/data/2.5/find"
        let queryItemQuery = URLQueryItem(name: "q", value: query)
        let queryItemType = URLQueryItem(name: "type", value: "liki")
        let queryItemUnits = URLQueryItem(name:"units", value: "metric")
        let queryItemAppId = URLQueryItem(name:"appid", value: "d8b585f530bf87bf33de4f4939f30f63")
        searchURLComponents?.queryItems = [queryItemQuery,queryItemType, queryItemUnits, queryItemAppId]

        let searchURL = searchURLComponents?.url!
        print(searchURL as Any!)
        
        let task = URLSession.shared.dataTask(with: searchURL!, completionHandler: { (data, response, error) in
            var cities = [City]()
            if error != nil {
                print(error!)
            } else {
                if let urlContent = data {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
//                        print(jsonResult)
                        if((jsonResult as? [String : Any]) != nil) {
                            if let list = jsonResult["list"]! as? [[String: Any]] {
                                for case let city in list {
                                    if let city = City(json: city) {
                                        cities.append(city)
                                        print("******** \(cities.count)")
                                    }
                                    print("**** The name of the object is \(city["name"]!)")
                                    if let temp = city["main"] as? [String : Any] {
                                        print("**** and temperature there is \(temp["temp"]!) degrees celsius")
                                    }
                                }
//                                if let dictionary = list.first as? [String : Any] {
//                                    if let temp = dictionary["main"] as? [String : Any] {
//                                        print("Temperature in \(dictionary["name"]!) is \(temp["temp"]!)")
//                                    }
//                                }
                            }
                        }

                    } catch {
                        print("JSON Processing Failed")
                    }
                }
            }
            completion(cities)
        })
        task.resume()
    }
}



