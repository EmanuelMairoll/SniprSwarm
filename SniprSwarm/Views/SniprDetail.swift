//
//  SniprDetail.swift
//  SniprSwarm
//
//  Created by Emanuel Mairoll on 22.05.21.
//

import SwiftUI
import SniprSwarmCore

struct SniprDetail: View {
    var snipr: Snipr

    var dateFormatter:DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "yyyy.MM.dd HH:mm:ss"
        return format
    }()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 24) {

                    AsyncResource(url: snipr.thumbnailUrl) { img in
                        img
                            .resizable()
                            .frame(width: 150, height: 150)
                            .cornerRadius(5)
                    }

                    VStack(alignment: .leading) {
                        Spacer()
                        Text(snipr.name)
                            .font(.title)
                            .bold()
                        Text(snipr.desc)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(dateFormatter.string(from: snipr.assassination))
                            .font(.callout)
                    }
                }

                Divider()

                Text("Lorem Ipsum")
            }
            .padding()
            .frame(maxWidth: 700)

        }
        .navigationTitle(snipr.name)
    }
}

struct SniprDetail_Previews: PreviewProvider {
    static var previews: some View {
        SniprDetail(snipr: Examples.snipr1)
    }
}
