//
//  Storage.swift
//  WeatherApp
//
//  Created by Alvar Aronija on 16/03/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

import Foundation

class Storage {
    fileprivate init() {}
    
    static var DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("favorites")
    
    static func save<T: Encodable>(_ object: T) -> Bool {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            return FileManager.default.createFile(atPath: ArchiveURL.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static func load<T: Decodable>(_ type: T.Type) -> T {
        // TODO: check if file exists
        
        if let data = FileManager.default.contents(atPath: ArchiveURL.path) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(type, from: data)
                return model
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("No data at \(ArchiveURL.path)")
        }
    }
}

