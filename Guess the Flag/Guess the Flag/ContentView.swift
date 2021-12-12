//
//  ContentView.swift
//  Guess the Flag
//
//  Created by Kuba Milcarz on 13/11/2021.
//

import SwiftUI

struct ContentView: View {
    let accentClr = Color.mint
    
    @State private var showingScore = false
    @State private var showingGameRestart = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var isLastRoundLost = false
    
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var isBtnTapped = [0, 0, 0]
    @State private var btnTapped = false
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                RadialGradient(stops: [
                    .init(color: .black, location: 0.3),
                    .init(color: accentClr, location: 0.3),
                ], center: .top, startRadius: 200, endRadius: 700)
                    .ignoresSafeArea()
                VStack(spacing: 30) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Tap the flag of")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.secondary)
                            Text(countries[correctAnswer])
                                .font(.largeTitle.weight(.light))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Score")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.secondary)
                            Text("\(score)")
                                .font(.largeTitle.weight(.light))
                                .foregroundColor(accentClr)
                        }
                    }
                    
                    Spacer()
                    
                    ForEach(0..<3) { number in
                        Button {
                            withAnimation(.interpolatingSpring(stiffness: 7, damping: 3)) {
                                flagTapped(number)
                                isBtnTapped[number] += 360
                                btnTapped.toggle()
                            }
                        } label: {
                            FlagImage(src: countries[number])
                        }
                        .opacity(btnTapped ? 0.25 : 1)
                        .scaleEffect(btnTapped ? 0.75 : 1)
                        .rotation3DEffect(.degrees(Double(isBtnTapped[number])), axis: (x: 0, y: 1, z: 0))
                        
                    }
                    
                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding([.vertical, .horizontal])
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
            }
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is \(score)")
            }
            .alert(scoreTitle, isPresented: $showingGameRestart) {
                Button("Restart", role: .destructive, action: resetGame)
            } message: {
                Text("Congrats! You've scored 8 out of 8 points! Restart the game to continue!")
            }
            
            .navigationTitle("Guess the Flag")
        }
        
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            
            if score == 8 {
                showingGameRestart = true
            } else {
                showingScore = true
            }
            
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
            isLastRoundLost = true
            showingScore = true
        }
    }
    
    func askQuestion() {
        if isLastRoundLost || score > 8 {
            resetGame()
            isLastRoundLost = false
            return
        }
        
        withAnimation(.interpolatingSpring(stiffness: 7, damping: 3)) {
            btnTapped = false
            countries.shuffle()
        }

        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        score = 0
        correctAnswer = Int.random(in: 0...2)
        
        withAnimation(.interpolatingSpring(stiffness: 7, damping: 3)) {
            btnTapped = false
            countries.shuffle()
        }
    }
    
}

struct FlagImage: View {
    
    var src: String
    
    var body: some View {
        Image(src)
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 9))
            .shadow(radius: 5)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
.previewInterfaceOrientation(.portrait)
    }
}
