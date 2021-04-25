//
//  Persistance.swift
//  SnprSwrm
//
//  Created by Emanuel Mairoll on 25.04.21.
//

import Foundation



public extension Array where Element == Identity {
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "Identities")
        }
    }
    
    static func load() -> [Identity]?{
        if let identities = UserDefaults.standard.object(forKey: "Identities") as? Data {
            let decoder = JSONDecoder()
            return try? decoder.decode([Identity].self, from: identities)
        }
        return nil
    }
}
