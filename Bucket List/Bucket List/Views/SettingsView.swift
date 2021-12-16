//
//  SettingsView.swift
//  Bucket List
//
//  Created by Kuba Milcarz on 15/12/2021.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isUnlocked: Bool
    
    var body: some View {
        NavigationView {
            List {
                Text("Settings row")
                Text("Settings row")
                Text("Settings row")
                Text("Settings row")
                HStack {
                    Spacer()
                    Button(role: .destructive) {
                        isUnlocked = false
                    } label: {
                        Text("Lock")
                            .padding(.horizontal)
                    }
                    .buttonStyle(.bordered).tint(.red)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                Button("Hide") {
                    dismiss()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isUnlocked: .constant(false))
    }
}
