//
//  File.swift
//  
//
//  Created by Emanuel Mairoll on 20.05.21.
//

import Foundation
import SniprSwarmCore

public struct Examples {
    public static let identity1 = Identity(email: "mail@example.com", password: "pass1234", street: "Street", number: 1, zip: 1234, city: "City", country: "Austria", creditCard: 111122223334444, validThruMonth: 01, validThruYear: 2000, securityCode: 123)
    public static let identity2 = Identity(email: "test@example.com", password: "pass1234", street: "Street", number: 1, zip: 1234, city: "City", country: "Austria", creditCard: 111122223334444, validThruMonth: 01, validThruYear: 2000, securityCode: 123)
    public static let tactic = SniprTactic(name: "TestLambda", arn: "arn:aws:lambda:eu-central-1:238438322436:function:TestLambda", successSignal: "SIGNAL: SUCCESS", failureSignal: "SIGNAL: FAILURE")
    public static let snipr1 = Snipr(
        name: "Pure Platinum",
        desc: "Air Max Pre-Day",
        assassination: Date(),
        baseOffetSeconds: 10,
        respectiveOffetSeconds: 5,
        link: "http://test",
        size: "EU45",
        thumbnailUrl: "https://static.nike.com/a/images/t_prod_ss/w_640,c_limit,f_auto/431dad98-032f-431e-bfb9-8f5f6d402f2a/air-max-pre-day-pure-platinum-release-date.jpg",
        sniprTacticArn: "arn:aws:lambda:eu-central-1:238438322436:function:TestLambda",
        identities: [identity1, identity2]
    )
    public static let snipr2 = Snipr(
        name: "Velvet Brown",
        desc: "Waffle Trainer 2",
        assassination: Date(),
        baseOffetSeconds: 10,
        respectiveOffetSeconds: 5,
        link: "http://test",
        size: "EU45",
        thumbnailUrl: "https://static.nike.com/a/images/t_prod_ss/w_640,c_limit,f_auto/37147cfc-73d8-4646-8039-6527a77b3ced/waffle-trainer-2-velvet-brown-release-date.jpg",
        sniprTacticArn: "arn:aws:lambda:eu-central-1:238438322436:function:TestLambda",
        identities: [identity1, identity2]
    )

}

