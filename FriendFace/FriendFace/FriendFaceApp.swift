//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by Kuba Milcarz on 09/12/2021.
//

import SwiftUI

@main
struct FriendFaceApp: App {
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
