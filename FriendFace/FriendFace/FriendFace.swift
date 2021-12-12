//
//  FriendFace.swift
//  FriendFace
//
//  Created by Kuba Milcarz on 09/12/2021.
//

import Foundation

class FriendFace: ObservableObject {
    @Published var users = [User]()
    
//    init() {
//        if self.users.isEmpty {
//            guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
//                print("[ContentView] load users failed: invalid URL")
//                return
//            }
//
//            let request = URLRequest(url: url)
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .iso8601
//                if let data = data, let decoded = try? decoder.decode([User].self, from: data) {
//                    self.users = decoded
//                    print("[ContentView] load from web")
//                } else {
//                    print("[ContentView] load users failed: response error \(error?.localizedDescription ?? "Unknown Error")")
//                }
//            }
//            .resume()
//        }
//    }
}
