//
//  Types.swift
//  SnprSwrm
//
//  Created by Emanuel Mairoll on 24.04.21.
//

import Foundation

public struct Snipr {
    public var name: String
    public var desc: String
    
    public var assassination: Date
    public var offsetSeconds: Int
    
    public var link: String
    public var size: String
    
    public var sniprTactic: SnprTactic
    public var identities: [Identity]
}

public struct SnprTactic {
    public var name: String
    public var arn: String
    public var content: Data?
}

public struct Identity: Codable, Equatable {
    public var email: String
    public var password: String
    
    public var street: String
    public var number: UInt16
    public var zip: UInt16
    public var city: String
    public var country: String
    
    public var creditCard: UInt64
    public var validThruMonth: UInt8
    public var validThruYear: UInt16
    public var securityCode: UInt16
}
