//
//  SniprRow.swift
//  SniprSwarm
//
//  Created by Emanuel Mairoll on 14.05.21.
//

import SwiftUI
import SniprSwarmCore

struct SniprRow: View {
    var snipr: Snipr

    var body: some View {
        HStack {
            AsyncResource(url: snipr.thumbnailUrl) { img in
                img
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
            }

            VStack(alignment: .leading) {
                Text(snipr.name)
                    .font(.title2)
                    .bold()
                Text(snipr.desc)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            /*
            if landmark.hasState {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }*/
        }
        .padding(.vertical, 4)
    }
}

struct SniprRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SniprRow(snipr: Examples.snipr1)
            SniprRow(snipr: Examples.snipr2)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
