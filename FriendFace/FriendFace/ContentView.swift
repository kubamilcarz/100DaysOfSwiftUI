//
//  ContentView.swift
//  FriendFace
//
//  Created by Kuba Milcarz on 09/12/2021.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [ SortDescriptor(\.name) ]) var users: FetchedResults<CachedUser>
    
    @State private var finishedDownloading = false
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Spacer()
                    Text("Showing \(users.count) friends")
                        .font(.subheadline)
                    Spacer()
                }
                
                ForEach(users) { user in
                    VStack {
                        NavigationLink(destination: UserDetailView(user: user)) {
                            UserRow(user: user)
                        }
                    }
                }
                
                Section("The Board") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Jakub Milcarz")
                                .font(.headline)
                                .foregroundColor(.yellow)
                            Text("Chief Excutive Officer")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("89%")
                            .font(.subheadline)
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Kacper Kondraszuk")
                                .font(.headline)
                            Text("Shareholder")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("11%")
                            .font(.subheadline)
                    }
                }
            }
            .redacted(reason: finishedDownloading ? [] : .placeholder)
            
            .task {
                await loadData()
            }
            
            .navigationTitle("SFS Network")
        }
    }
    
    func loadData() async {
        guard users.isEmpty else { return }
        
        do {
            let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let users = try decoder.decode([User].self, from: data)
            
            await MainActor.run {
                updateCache(with: users)
            }
            
            finishedDownloading = true
        } catch {
            print("Download failed")
        }
    }
    
    func updateCache(with webUsers: [User]) {
        do {
            for webUser in webUsers {
                let cachedUser = CachedUser(context: moc)
                cachedUser.id = webUser.id
                cachedUser.isActive = webUser.isActive
                cachedUser.name = webUser.name
                cachedUser.age = Int16(webUser.age)
                cachedUser.company = webUser.company
                cachedUser.email = webUser.email
                cachedUser.address = webUser.address
                cachedUser.about = webUser.about
                cachedUser.registered = webUser.registered
                cachedUser.tags = webUser.tags.joined(separator: ",")
                
                for friend in webUser.friends {
                    let cachedFriend = CachedFriend(context: moc)
                    cachedFriend.id = friend.id
                    cachedFriend.name = friend.name
                    
                    cachedUser.addToFriends(cachedFriend)
                }
            }
            try moc.save()
            
        } catch {
            print("Convertion to CachedUser failed")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
