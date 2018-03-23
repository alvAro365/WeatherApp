//
//  City.swift
//  WeatherApp
//
//  Created by Alvar Aronija on 12/03/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

import Foundation


struct City: Codable {
    
    let name: String
    let temperature: Int
    let wind: Float
    let icon: String
    let description: String
    var favorites =  [City]()
    let country: String
    let cityId: Int

    private let icons = ["01d": "☀️","02d": "⛅️","03d": "☁️","04d": "☁️","09d": "🌧","10d": "🌦","11d": "🌩","13d": "🌨","50d": "🌫","01n": "🌙","02n": "☁️","03n": "☁️","04n": "☁️","09n": "🌧","10n": "🌧","11n": "🌩","13n": "🌨","50n": "🌫"]
}

extension City {
    init?(json: [String : Any]) {
        guard let name = json["name"] as? String,
            let temperatureJSON = json["main"] as? [String: Float],
            let temperature = temperatureJSON["temp"],
            let windJSON = json["wind"] as? [String: Float],
            let wind = windJSON["speed"],
            let weatherJSON = json["weather"] as? [[String: Any]],
            let weatherData = weatherJSON.first,
            let iconID = weatherData["icon"] as? String,
            let weatherDescription = weatherData["main"] as? String,
            let countryJSON = json["sys"] as? [String: String],
            let country = countryJSON["country"],
            let cityId = json["id"] as? Int
        
        else {
                return nil
        }
        self.name = name
        self.temperature = Int(temperature)
        self.wind = wind
        self.description = weatherDescription
        self.icon = self.icons[iconID]!
        self.country = country
        self.cityId = cityId
        print("Name: \(self.name), Temperature: \(self.temperature), Wind: \(self.wind), Icon: \(iconID), Description: \(description), Country: \(country), ID: \(cityId)")
    }
}

extension City {
    init?(updateJson: [String : Any]) {
//        print("Update json: \(String(describing: updateJson["name"]))")
        guard let nameJson = updateJson["name"] as? String
//        let name = nameJson["name"]
            else {
                return nil
        }
        self.name = ""
        self.temperature = 0
        self.wind = 0.0
        self.description = ""
        self.icon = self.icons["01d"]!
        self.country = ""
        self.cityId = 0
//        print("NameJson: \(nameJson)")
        print("Name: \(nameJson)")
    }
}

extension City {
    
    static func cities(matching query: String?, updating queryUpdate: [String]?, completion: @escaping ([City]) -> Void) {
        let url: URL?
        if query != nil {
            url = createSearchUrlComponents(query: query!)
        } else {
            url = createUpdateDataUrlComponents(query: queryUpdate!)
        }
        
//        let searchURL = createSearchUrlComponents(query: query!)
//        let updateURL = createUpdateDataUrlComponents(query: ["3143244", "588409"])
//        print(updateURL)
//        print(searchURL as Any!)
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            var cities = [City]()
            if let theError = error {
                print(theError)
            } else {
                let options = JSONSerialization.ReadingOptions()
                if let urlContent = data {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: options) as AnyObject
//                        print(jsonResult)
                        if((jsonResult as? [String : Any]) != nil) {
//                            print("JsonResult: \(jsonResult)")
                            if let list = jsonResult["list"]! as? [[String: Any]] {
//                                print("The list is:  \(list)")
                               
                                for case let city in list {
                                    print("*****city: \(city)")
//                                    if let city = City(json: city) {
//                                        print("City: \(city)")
//                                    }
                                    if let city = City.init(updateJson: city) {
                                        print("City: \(city)")
                                        cities.append(city)
                                        print("******** \(cities.count)")
                                    }
                                }
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
    private static func createSearchUrlComponents(query: String) -> URL {
        var searchURLComponents = URLComponents.init(string: "http://api.openweathermap.org")
        searchURLComponents?.path = "/data/2.5/find"
        let queryItemQuery = URLQueryItem(name: "q", value: query)
        let queryItemType = URLQueryItem(name: "type", value: "like")
        let queryItemUnits = URLQueryItem(name:"units", value: "metric")
        let queryItemAppId = URLQueryItem(name:"appid", value: "d8b585f530bf87bf33de4f4939f30f63")
        searchURLComponents?.queryItems = [queryItemQuery,queryItemType, queryItemUnits, queryItemAppId]
        return (searchURLComponents?.url)!
    }
    
    private static func createUpdateDataUrlComponents(query: [String]) -> URL {
        var searchURLComponents = URLComponents.init(string: "http://api.openweathermap.org")
        searchURLComponents?.path = "/data/2.5/group"
        
        let groupQuery = query.joined(separator: ",")
        let queryItemQuery = URLQueryItem(name: "id", value: groupQuery)
        let queryItemUnits = URLQueryItem(name:"units", value: "metric")
        let queryItemAppId = URLQueryItem(name:"appid", value: "d8b585f530bf87bf33de4f4939f30f63")
        searchURLComponents?.queryItems = [queryItemQuery, queryItemUnits, queryItemAppId]
        return (searchURLComponents?.url)!
        
    }
    
    
    
}




