//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Kuba Milcarz on 15/11/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var siriScore: Int = 0
    @State private var playerScore: Int = 0
        
    @State private var siriSymbol: Int = Int.random(in: 0...2)
    @State private var playerSymbol: Int = 0
    
    @State private var randomizedAction: Bool = Bool.random()
    
    @State private var showingRoundResults: Bool = false
    @State private var showingGameResults: Bool = false
    
    let symbols = ["✊", "✋", "✌️"]
    let actions = ["win", "lose"]
    
    enum WhoWonType {
        case player, siri, draw
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .teal], startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea()
            VStack(spacing: 30) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Siri")
                            .foregroundStyle(.white)
                            .font(.headline)
                        Text("\(siriScore)")
                            .foregroundColor(.black)
                            .font(.largeTitle)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Player")
                            .foregroundStyle(.white)
                            .font(.headline)
                        Text("\(playerScore)")
                            .foregroundColor(.black)
                            .font(.largeTitle)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 10) {
                    Text(actions[randomizedAction ? 1 : 0])
                        .font(.system(size: 40).weight(.bold))
                        .textCase(.uppercase)
                        .foregroundColor(randomizedAction ? .red : .green)
                    Text("against")
                        .font(.headline.weight(.light).italic())
                    Text(symbols[siriSymbol])
                        .font(.system(size: 150))
                        .rotationEffect(Angle(degrees: 180))
                }
                
                Spacer()
                
                VStack(spacing: 10) {
                    Text("Choose")
                        .font(.title2)
                        .textCase(.uppercase)
                    HStack(spacing: 30) {
                        Button(symbols[0]) {
                            play(symbol: symbols[0])
                        }
                        .font(.system(size: 70))
                        Button(symbols[1]) {
                            play(symbol: symbols[1])
                        }
                        .font(.system(size: 70))
                        Button(symbols[2]) {
                            play(symbol: symbols[2])
                        }
                        .font(.system(size: 70))
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
            .background(.thinMaterial)
        }
        .alert("Rock Paper Scissors", isPresented: $showingRoundResults) {
            Button("continue", action: { })
        } message: {
            Text("Your current score is: \(playerScore)/10")
        }
        .alert("Rock Paper Scissors", isPresented: $showingGameResults) {
            Button("continue", action: { resetGame() })
        } message: {
            if playerScore > siriScore {
                Text("You won! Good Game!")
            } else {
                Text("You lost :(")
            }
            
        }
    }
    
    
    func play(symbol: String) {
        switch symbol {
            case "✊":
                playerSymbol = 0
            case "✋":
                playerSymbol = 1
            case "✌️":
                playerSymbol = 2
            default:
                print("Something went wrong with playerSymbol conversion")
        }
        
        let result = whoWon(player: playerSymbol, siri: siriSymbol)
        print("this round has been won by \(result)!")
        
        if result != .draw {
            if actions[randomizedAction ? 1 : 0] == "win" {
                // you are playing to win
                
                if result == .player {
                    // you won congrats alert
                    playerScore += 1
                } else {
                    // you lose despite you had to win
                    siriScore += 1
                }
                
            } else {
                // you are playing to lose

                if result == .siri {
                    // you lose congrats alert
                    playerScore += 1
                } else {
                    // you won despite you had to lose
                    siriScore += 1
                }
                
            }
        } else {
            // draw
            
        }
        
        if playerScore >= 10 || siriScore >= 10 {
            showingGameResults = true
            return
        }
        
        showingRoundResults = true
        
        siriSymbol = Int.random(in: 0...2)
        randomizedAction = Bool.random()
    }
    
    func resetGame() {
        showingRoundResults = false
        showingGameResults = false
        
        siriScore = 0
        playerScore = 0
        
        siriSymbol = Int.random(in: 0...2)
        randomizedAction = Bool.random()
    }
    
    // return types: "player", "siri", "draw"
    func whoWon(player: Int, siri: Int) -> WhoWonType {
        /*
         |  rock - 0
         |  paper - 1
         |  scissors - 2
         */
        
        if player == siri {
            return .draw
        }
        
        
        if player == 0 {
            if siri == 1 {
                return .siri
            } else {
                return .player
            }
        } else if player == 1 {
            if siri == 2 {
                return .siri
            } else {
                return .player
            }
        } else {
            if siri == 0 {
                return .siri
            } else {
                return .player
            }
        }
        
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
