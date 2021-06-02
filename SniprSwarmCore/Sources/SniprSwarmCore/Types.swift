//
//  Types.swift
//  SnprSwrm
//
//  Created by Emanuel Mairoll on 24.04.21.
//

import Foundation
import SotoEventBridge
import SotoLambda
import NIO

public typealias Futr = EventLoopFuture
public typealias EB = EventBridge
public typealias LB = Lambda


//------------------------------------SNIPR Model------------------------------------//

public struct Snipr: Hashable {
    public init(name: String, desc: String, assassination: Date, baseOffetSeconds: Int, respectiveOffetSeconds: Int, link: String, size: String, thumbnailUrl: String, sniprTacticArn: String, identities: [Identity]) {
        self.name = name
        self.desc = desc
        self.assassination = assassination
        self.baseOffetSeconds = baseOffetSeconds
        self.respectiveOffetSeconds = respectiveOffetSeconds
        self.link = link
        self.size = size
        self.thumbnailUrl = thumbnailUrl
        self.sniprTacticArn = sniprTacticArn
        self.identities = identities
    }    

    public var name: String
    public var desc: String
    
    public var assassination: Date
    public var baseOffetSeconds: Int
    public var respectiveOffetSeconds: Int

    public var link: String
    public var size: String
    public var thumbnailUrl: String

    public var sniprTacticArn: String
    public var identities: [Identity]
}

public struct SniprTactic: Hashable {
    public init(name: String, arn: String, successSignal: String, failureSignal: String, desc: String? = nil) {
        self.name = name
        self.arn = arn
        self.successSignal = successSignal
        self.failureSignal = failureSignal
        self.desc = desc
    }

    public var name: String
    public var arn: String
    public var successSignal: String
    public var failureSignal: String

    public var desc: String?
}


//------------------------------------AWS Model------------------------------------//

public struct TargetInput: Codable, Equatable {
    public var identity: Identity
    public var offsetSeconds: Int
    public var link: String
    public var size: String
}


public enum RuleToSniprTags: String {
    case baseOffetSeconds = "BaseOffsetSeconds"
    case respectiveOffetSeconds = "RespectiveOffsetSeconds"
    case link = "Link"
    case size = "Size"
    case thumbnailUrl = "ThumbnailUrl"
    case sniprTacticName = "SniprTacticName"
    case sniprTacticARN = "SniprTacticARN"
}

public enum LambdaToTacticTags: String {
    case successSignal = "SuccessSignal"
    case failureSignal = "FailureSignal"
}

//------------------------------------Shared------------------------------------//

public struct Identity: Hashable, Codable, Equatable {
    public init(email: String, password: String, street: String, number: UInt16, zip: UInt16, city: String, country: String, creditCard: UInt64, validThruMonth: UInt8, validThruYear: UInt16, securityCode: UInt16) {
        self.email = email
        self.password = password
        self.street = street
        self.number = number
        self.zip = zip
        self.city = city
        self.country = country
        self.creditCard = creditCard
        self.validThruMonth = validThruMonth
        self.validThruYear = validThruYear
        self.securityCode = securityCode
    }

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
