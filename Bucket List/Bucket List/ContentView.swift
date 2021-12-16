//
//  ContentView.swift
//  Bucket List
//
//  Created by Kuba Milcarz on 14/12/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var isUnlocked = false
    
    var body: some View {
        if isUnlocked {
            AppView(isUnlocked: $isUnlocked)
        } else {
            AuthenticateView(isUnlocked: $isUnlocked)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
