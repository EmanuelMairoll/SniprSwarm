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

public struct Snipr {
    public var name: String
    public var desc: String
    
    public var assassination: Date
    public var baseOffetSeconds: Int
    public var respectiveOffetSeconds: Int

    public var link: String
    public var size: String
    public var thumbnailUrl: String

    public var sniprTactic: SniprTactic
    public var identities: [Identity]
}

public struct SniprTactic {
    public var name: String
    public var arn: String
    public var desc: String?
}


//------------------------------------AWS Model------------------------------------//

public struct TargetInput: Codable, Equatable {
    public var identity: Identity
    public var offsetSeconds: Int
    public var link: String
    public var size: String
}

public enum RoleTag: String {
    case baseOffetSeconds = "BaseOffsetSeconds"
    case respectiveOffetSeconds = "RespectiveOffsetSeconds"
    case link = "Link"
    case size = "Size"
    case thumbnailUrl = "ThumbnailUrl"
    case sniprTacticName = "SniprTacticName"
    case sniprTacticARN = "SniprTacticARN"
}

//------------------------------------Shared------------------------------------//

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
