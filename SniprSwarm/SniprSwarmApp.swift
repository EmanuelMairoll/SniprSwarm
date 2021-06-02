//
//  SniprSwarmApp.swift
//  SniprSwarm
//
//  Created by Emanuel Mairoll on 01.05.21.
//

import SwiftUI

@main
struct SniprSwarmApp: App {
    @StateObject private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
