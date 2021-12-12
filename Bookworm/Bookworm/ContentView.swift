//
//  ContentView.swift
//  Bookworm
//
//  Created by Kuba Milcarz on 04/12/2021.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.finishedOn, order: .reverse),
        SortDescriptor(\.author),
        SortDescriptor(\.title)
    ]) var books: FetchedResults<Book>
    
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        BookRowView(book: book)
                    }
                }.onDelete(perform: deleteBook)
            }
            .navigationBarTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Label("Add Book", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddBookView()
            }
        }
    }
    
    func deleteBook(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let book = books[offset]
            
            // delete it from the context
            moc.delete(book)
        }
        
        // save the context
        try? moc.save()
    }
}

struct BookRowView: View {
    var book: Book
    var finished: String
    
    init(book: Book) {
        self.book = book
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let date = book.finishedOn ?? Date.now
        finished = formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            StarRating(rating: .constant(book.rating))
                .font(.caption)
                .padding(.bottom, 0)
            Text(book.title ?? "Unknown Title")
                .font(.headline)
            Text("\(book.author ?? "Unknown Author") (\(finished))")
                .foregroundColor(.secondary)
        }.foregroundColor(book.rating == 1 ? .red : .primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
