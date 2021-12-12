//
//  UserDetailView.swift
//  FriendFace
//
//  Created by Kuba Milcarz on 09/12/2021.
//

import SwiftUI

struct UserDetailView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [ SortDescriptor(\.name) ]) var users: FetchedResults<CachedUser>
    
    var user: CachedUser
    
    var body: some View {
        List {
            Section("Personal Info") {
                Text("email: \(user.wrappedEmail)")
                Text("company: \(user.wrappedCompany)")
                Text("age: \(user.age)")
            }
            
            Section("About") {
                Text(user.wrappedAbout)
                    .padding(.vertical, 10)
            }
            
            Section("Tags") {
                ScrollView([.horizontal], showsIndicators: false) {
                    HStack {
                        ForEach(user.tagsArray, id: \.self) { tag in
                            Text(tag)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .background(Capsule().fill(.thickMaterial))
                        }
                    }
                }
            }
            
            Section("\(user.friendsArray.count) Friends") {
                ForEach(user.friendsArray, id: \.id) { friend in
                    NavigationLink {
                        let destined = findUser(by: friend.id!)
                        UserDetailView(user: destined)
                    } label: {
                        Text(friend.wrappedName)
                    }
                }
            }
            
            Section("Friend Face") {
                Text("Registered: \(user.wrappedRegistered)")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "circle.fill")
                    .font(.subheadline)
                    .foregroundColor(user.isActive ? .green : .red)
            }
        }
        
        .navigationTitle(user.wrappedName)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func findUser(by id: UUID) -> CachedUser {
        users.first(where: { $0.id == id }) ?? users[0]
    }
}
