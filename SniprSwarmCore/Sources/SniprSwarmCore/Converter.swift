//
//  Converter.swift
//  SniprSwarmData
//
//  Created by Emanuel Mairoll on 26.04.21.
//

import Foundation
import SotoEventBridge
public extension Snipr {
    typealias EB = EventBridge
    
    init(rule: EB.Rule, targets: [EB.Target]) throws {
        
        rule.
        
        self.init(
            name: rule.name,
            desc: rule.description,
            assassination: Date(fromCronExpression: rule.scheduleExpression),
            offsetSeconds: rule.,
            link: <#T##String#>,
            size: <#T##String#>,
            sniprTactic: <#T##SnprTactic#>,
            identities: <#T##[Identity]#>)
    }
    
    
    
}

extension Date {
    
    init(fromCronExpression: String) {
        
    }
    
    func toCronExpression() throws -> String  {
        
    }
}

