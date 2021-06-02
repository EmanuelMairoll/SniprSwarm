//
//  AsyncImage.swift
//  SniprSwarm
//
//  Created by Emanuel Mairoll on 19.05.21.
//

import SwiftUI

struct AsyncResource<Content> : View where Content : View {
    @StateObject private var loader: Loader
    private var content: (AsyncResource.LoadState, Data) -> Content

    var body: some View {
        content(loader.state, loader.data)
    }

    @inlinable init(url: String, @ViewBuilder content: @escaping (AsyncResource.LoadState, Data) -> Content) {
        _loader = StateObject(wrappedValue: Loader(url: url))
        self.content = content;
    }

    public enum LoadState {
        case loading, success, failure
    }

    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.loading

        init(url: String) {
            guard let parsedURL = URL(string: url) else {
                fatalError("Invalid URL: \(url)")
            }

            let request = URLRequest(url: parsedURL, cachePolicy: .returnCacheDataElseLoad)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data, data.count > 0 {
                    self.data = data
                    self.state = .success
                } else {
                    self.state = .failure
                }

                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }.resume()
        }
    }
}

extension AsyncResource {
    @inlinable init(url: String, @ViewBuilder imageBuilder: @escaping (Image) -> Content) {
        _loader = StateObject(wrappedValue: Loader(url: url))
        //self.content = content;

        self.content = { loadState, data in
            switch loadState {
            case .loading:
                return imageBuilder(Image(systemName: "photo"))
            case .failure:
                return imageBuilder(Image(systemName: "multiply.circle"))
            default:
                if let image = NSImage(data: data) {
                    return imageBuilder(Image(nsImage: image))
                } else {
                    return imageBuilder(Image(systemName: "multiply.circle"))
                }
            }
        }
    }
}

struct AsyncResource_Previews: PreviewProvider {
    static var previews: some View {
        let url = "https://static.nike.com/a/images/t_prod_ss/w_960,c_limit,f_auto/aa683128-46c9-45c7-8dd4-1a82d85bb337/air-max-pre-day-pure-platinum-release-date.jpg"
        AsyncResource(url: url) { img in
            img
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(5)

        }
    }
}
