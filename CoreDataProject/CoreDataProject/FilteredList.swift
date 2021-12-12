//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Kuba Milcarz on 07/12/2021.
//

import CoreData
import SwiftUI

enum FilteredPredicates: String, CaseIterable {
    case beginsWith = "BEGINSWITH"
    case endsWith = "ENDSWITH"
    case like = "LIKE"
    case matches = "MATCHES"
    case contains = "CONTAINS"
}

struct FilteredList<T: NSManagedObject, Content: View>: View {
    @FetchRequest var fetchRequest: FetchedResults<T>
    
    // content closure
    let content: (T) -> Content
    
    init(filterKey: String, filterValue: String, predicate: FilteredPredicates, @ViewBuilder content: @escaping (T) -> Content) {
        
        if filterValue == "" {
            _fetchRequest = FetchRequest<T>(sortDescriptors: [])
        } else {
            _fetchRequest = FetchRequest<T>(sortDescriptors: [], predicate: NSPredicate(format: "%K \(predicate.rawValue)[c] %@", filterKey, filterValue))
        }
        self.content = content
    }
    
    var body: some View {
        List(fetchRequest, id: \.self) { item in
            self.content(item)
        }
    }
}
