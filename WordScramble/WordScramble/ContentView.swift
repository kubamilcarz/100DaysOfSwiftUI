//
//  ContentView.swift
//  WordScramble
//
//  Created by Kuba Milcarz on 18/11/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var score = 0
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @FocusState private var isNewWordFocused
    
    // error messages
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .focused($isNewWordFocused)
                        .autocapitalization(.none)
                        .onSubmit(addNewWord)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Restart", action: startGame)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Score: \(score)")
                }
            }
            
            .navigationTitle(rootWord)
        }
    }
    
    func addNewWord() {
        guard newWord.count > 0 else { return }
        
        let result = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard isValid(word: result) else {
            wordError(title: "Word is invalid", message: "Remeber to type words longer than 3 characters and different from the original word")
            return
        }
        
        guard isOriginal(word: result) else {
            wordError(title: "Word used already", message: "C'mon! Be more original")
            return
        }
        
        guard isPossible(word: result) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: result) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        withAnimation {
            usedWords.insert(result, at: 0)
        }
        
        score += newWord.count
        
        isNewWordFocused = true
        newWord = ""
    }
    
    func startGame() {
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")

                // 4. Pick one random word, or use "silkworm" as a sensible default
                
                withAnimation {
                    usedWords = [String]()
                }
                rootWord = allWords.randomElement() ?? "silkworm"
                score = 0
                newWord = ""
                isNewWordFocused = true

                // If we are here everything has worked, so we can exit
                return
            }
        }
        
        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var temp = rootWord
        
        for letter in word {
            if let position = temp.firstIndex(of: letter) {
                temp.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isValid(word: String) -> Bool {
        if word == rootWord || word.count < 3 {
            return false
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
