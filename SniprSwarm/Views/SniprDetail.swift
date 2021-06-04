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
        format.dateFormat = "yyyy.MM.dd HH:mm"
        return format
    }()

    var timeText: String {
        let ass = dateFormatter.string(from: snipr.assassination)
        let base = snipr.baseOffsetSeconds
        let resp = snipr.respectiveOffsetSeconds
        return "\(ass) +\(base)B+\(resp)R"
    }

    var linkText: String {
        let maxLen = 30
        if (snipr.link.count > maxLen) {
            let lastSlashIndex = snipr.link.lastIndex(of: "/")
            let sub = snipr.link.suffix(maxLen - 3)
            return "...\(sub)"
        } else {
            return snipr.link
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 24) {
                    VStack(alignment: .leading) {
                        Spacer()

                        Text(snipr.name)
                            .font(.largeTitle)
                            .bold()
                        Text(snipr.desc)
                            .font(.callout)
                            .foregroundColor(.secondary)
                        Spacer()

                        HStack {
                            VStack(alignment: .trailing) {
                                Text("Website Link")
                                    .bold()
                                Text("Size / Option")
                                    .bold()
                                Text("Snipr Tactic")
                                    .bold()
                                Text("Assasination")
                                    .bold()
                            }
                            .fixedSize()
                            VStack(alignment: .leading) {
                                Link(destination: URL(string: snipr.link)!, label: {
                                    Text(linkText)
                                })
                                Text(snipr.size)
                                Text("SNKRS blub")
                                Text(timeText)
                            }
                        }
                    }

                    Spacer()

                    AsyncResource(url: snipr.thumbnailUrl) { img in
                        img
                            .resizable()
                            .frame(width: 200, height: 200)
                            .cornerRadius(5)
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
