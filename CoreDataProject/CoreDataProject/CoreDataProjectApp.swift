//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Kuba Milcarz on 07/12/2021.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
//            RelationshipsView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
