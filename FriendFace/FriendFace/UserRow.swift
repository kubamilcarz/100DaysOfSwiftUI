//
//  UserRow.swift
//  FriendFace
//
//  Created by Kuba Milcarz on 09/12/2021.
//

import SwiftUI

struct UserRow: View {
    var user: CachedUser
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(user.wrappedName)
                    .font(.headline)
                Text(user.wrappedCompany)
            }
            Spacer()
            Image(systemName: "circle.fill")
                .font(.subheadline)
                .foregroundColor(user.isActive ? .green : .red)
        }
    }
}
