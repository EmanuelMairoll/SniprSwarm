//
//  ContentView.swift
//  SniprSwarm
//
//  Created by Emanuel Mairoll on 01.05.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SniprList()
            .frame(minWidth: 700, minHeight: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
