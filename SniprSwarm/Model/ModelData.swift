//
//  ModelData.swift
//  SniprSwarm
//
//  Created by Emanuel Mairoll on 22.05.21.
//

import Cocoa
import SniprSwarmCore

final class ModelData: ObservableObject {
    let sniprService = SniprService()

    @Published var sniprs: [Snipr] = [Examples.snipr1, Examples.snipr2]

    

}
