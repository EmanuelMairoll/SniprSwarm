//
//  MainList.swift
//  SniprSwarm
//
//  Created by Emanuel Mairoll on 14.05.21.
//

import SwiftUI
import SniprSwarmCore

struct SniprList: View {
    let sniprService = SniprService()

    @EnvironmentObject var modelData: ModelData
    @State private var selected: Snipr?

    var pendingSniprs:[Snipr] {
        modelData.sniprs.filter { $0.assassination > Date() }
    }

    var pastSniprs:[Snipr] {
        modelData.sniprs.filter { $0.assassination <= Date() }
    }

    var body: some View {
        NavigationView {
            List(selection: $selected) {
                Section(header: Text("Pending Sniprs")) {
                    ForEach(pendingSniprs, id: \.hashValue) { snipr in
                        NavigationLink(destination: SniprDetail(snipr: snipr)) {
                            SniprRow(snipr: snipr)
                        }
                        .tag(snipr)
                    }
                }
                Section(header: Text("Past Sniprs")) {
                    ForEach(pastSniprs, id: \.hashValue) { snipr in
                        NavigationLink(destination: SniprDetail(snipr: snipr)) {
                            SniprRow(snipr: snipr)
                        }
                        .tag(snipr)
                    }
                }

            }
            .frame(minWidth: 300)
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        print("blub")
                    }, label: {
                        Label("Add", systemImage: "bag.badge.plus")
                    })
                }
            }

            Text("Select a Snipr")
        }
    }
}

struct MainList_Previews: PreviewProvider {
    static var previews: some View {
        SniprList()
            .environmentObject(ModelData())
    }
}
