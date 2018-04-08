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
    var isFavorite: Bool
    private let icons = ["01d": "☀️","02d": "⛅️","03d": "☁️","04d": "☁️","09d": "🌧","10d": "🌦","11d": "🌩","13d": "🌨","50d": "🌫","01n": "🌙","02n": "☁️","03n": "☁️","04n": "☁️","09n": "🌧","10n": "🌧","11n": "🌩","13n": "🌨","50n": "🌫"]
}

extension City {
    init?(updateJson: [String : Any], favorite: Bool) {
        guard let name = updateJson["name"] as? String,
        let temperatureJson = updateJson["main"] as? [String : Any],
        let temperature = temperatureJson["temp"] as? Float,
        let windJson = updateJson["wind"] as? [String : Any],
        let wind = windJson["speed"] as? Float,
        let weatherJson = updateJson["weather"] as? [[String : Any]],
        let weatherDescription = weatherJson.first,
        let description = weatherDescription["main"] as? String,
        let iconId = weatherDescription["icon"] as? String,
        let countryJson = updateJson["sys"] as? [String : Any],
        let country = countryJson["country"] as? String,
        let cityId = updateJson["id"] as? Int
            else {
                return nil
        }
        self.name = name
        self.temperature = Int(temperature)
        self.wind = wind
        self.description = description
        self.icon = self.icons[iconId]!
        self.country = country
        self.cityId = cityId
        self.isFavorite = favorite
        print("Name: \(name), Temperature: \(temperature), Wind: \(wind), Description: \(description), Icon: \(iconId), Country: \(country), CityId: \(cityId), Favorite: \(isFavorite)")
    }
}

extension City {
    static func cities(matching query: String?, updating queryUpdate: [String]?, completion: @escaping ([City]) -> Void) {
        let url: URL?
        var isFavorite: Bool?
        if query != nil {
            url = createUrl(query: query!, updateQuery: nil)
            isFavorite = false
        } else {
            url = createUrl(query: nil, updateQuery: queryUpdate)
            isFavorite = true
        }
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            var cities = [City]()
            if let theError = error {
                print(theError)
            } else {
                let options = JSONSerialization.ReadingOptions()
                if let urlContent = data {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: options) as AnyObject
                        if((jsonResult as? [String : Any]) != nil) {
                            if let list = jsonResult["list"]! as? [[String: Any]] {
                                for case let city in list {
                                    if let city = City.init(updateJson: city, favorite: isFavorite!) {
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
    private static func createUrl(query: String?, updateQuery: [String]?) -> URL {
        var searchURLComponents = URLComponents.init(string: "http://api.openweathermap.org")
        let queryItemQuery: URLQueryItem
        let queryItemType: URLQueryItem
        let queryItemUnits = URLQueryItem(name:"units", value: "metric")
        let queryItemAppId = URLQueryItem(name:"appid", value: "d8b585f530bf87bf33de4f4939f30f63")
        
        if query != nil {
            searchURLComponents?.path = "/data/2.5/find"
            queryItemQuery = URLQueryItem(name: "q", value: query)
            queryItemType = URLQueryItem(name: "type", value: "like")
            searchURLComponents?.queryItems = [queryItemQuery, queryItemType, queryItemUnits, queryItemAppId]
        } else {
            let groupQuery = updateQuery!.joined(separator: ",")
            queryItemQuery = URLQueryItem(name: "id", value: groupQuery)
            searchURLComponents?.path = "/data/2.5/group"
            searchURLComponents?.queryItems = [queryItemQuery, queryItemUnits, queryItemAppId]
        }
        return (searchURLComponents?.url)!
    }
}




