//
//  AddBookView.swift
//  Bookworm
//
//  Created by Kuba Milcarz on 05/12/2021.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating: Int16 = 0
    @State private var genre = ""
    @State private var review = ""
    @State private var finishedOn = Date.now
    
    // alert
    @State private var alertMessage = ""
    @State private var isAlertShowing = false
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller", "Nonfiction", "Biography", "Memoir", "Action", "Sci-fi", "Science", "Psychology", "Self-help", "Fiction"].sorted { $0 < $1 }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    DatePicker("Finished on", selection: $finishedOn, in: ...Date.now, displayedComponents: .date)
                }
                
                Section("Write a review") {
                    ZStack(alignment: .leading) {
                        if review.isEmpty {
                            Text("Write a review...")
                                .padding(.leading, 5)
                                .foregroundColor(.gray)
                        }
                        TextEditor(text: $review)
                    }
                    HStack {
                        Spacer()
                        StarRating(rating: $rating)
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button {
                            saveBook()
                            dismiss()
                        } label: {
                            Text("Save")
                                .frame(maxWidth: 120)
                                .padding(.vertical, 5)
                        }.buttonStyle(.bordered).tint(.accentColor).padding(.trailing, -20)
                    }
                }
                .listRowBackground(Color.clear)
            }
            .alert("Error", isPresented: $isAlertShowing) {
                Button("Ok") { }
            } message: {
                Text(alertMessage)
            }
            
            .navigationTitle("Add Book")
        }
    }
    
    private func saveBook() {
        
        if title.isEmpty || author.isEmpty || genre.isEmpty {
            alertMessage = "Title, Author and Genre must have a value."
            isAlertShowing = true
            return
        }
        
        if rating < 1 || rating > 5 {
            alertMessage = "Incorrect rating."
            isAlertShowing = true
            return
        }
        
        let newBook = Book(context: moc)
        newBook.id = UUID()
        newBook.title = title
        newBook.author = author
        newBook.rating = Int16(rating)
        newBook.genre = genre
        newBook.review = review
        newBook.finishedOn = finishedOn
        
        try? moc.save()
        
        dismiss()
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
