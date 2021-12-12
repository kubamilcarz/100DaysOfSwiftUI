//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Kuba Milcarz on 07/12/2021.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
//    @FetchRequest(sortDescriptors: []) var wizards: FetchedResults<Wizard>
    
//    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "universe == %@", "Star Trek")) var ships: FetchedResults<Ship>
    
    @State private var filterKey = "firstName"
    @State private var filterMatch = ""
    @State private var filterPredicates = FilteredPredicates.beginsWith
    
    var body: some View {
        VStack {
            FilteredList(filterKey: filterKey, filterValue: filterMatch, predicate: FilteredPredicates.endsWith) { (singer: Singer) in
                Text("\(singer.wrapeedFirstName) \(singer.wrappedLastName)")
            }
            
            Button("Add Examples") {
                let taylor = Singer(context: moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"
                
                let ed = Singer(context: moc)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"
                
                let adele = Singer(context: moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"
                
                try? moc.save()
            }
            
            HStack {
                Picker("Field", selection: $filterKey) {
                    Text("firstName")
                    Text("lastName")
                }
                TextField("\(filterPredicates.rawValue)...", text: $filterMatch)
                Picker("Action", selection: $filterPredicates) {
                    ForEach(FilteredPredicates.allCases, id: \.self) { value in
                        Text(value.rawValue)
                    }
                }
            }
           

        }
        
//        VStack {
//            List(ships, id: \.self) { ship in
//                Text(ship.name ?? "Unknown ship")
//            }
//
//            Button("Add Examples") {
//                let ship1 = Ship(context: moc)
//                ship1.name = "Enterprise"
//                ship1.universe = "Star Trek"
//
//                let ship2 = Ship(context: moc)
//                ship2.name = "Defiant"
//                ship2.universe = "Star Trek"
//
//                let ship3 = Ship(context: moc)
//                ship3.name = "Millenium Falcon"
//                ship3.universe = "Star Wars"
//
//                let ship4 = Ship(context: moc)
//                ship4.name = "Executor"
//                ship4.universe = "Star Wars"
//
//                try? moc.save()
//            }
//        }
        
        // add as many u want, but when saved all will collapse to one
//        VStack {
//            List(wizards, id: \.self) { wizard in
//                Text(wizard.name ?? "Unknown")
//            }
//
//            Button("Add") {
//                let wizard = Wizard(context: moc)
//                wizard.name = "Harry Potter"
//            }
//
//            Button("Save") {
//                withAnimation {
//                    do {
//                        try moc.save()
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//                }
//
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
