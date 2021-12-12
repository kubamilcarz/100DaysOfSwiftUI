//
//  ContentView.swift
//  Habits Tracker
//
//  Created by Kuba Milcarz on 29/11/2021.
//
//  The code works well, though if I were you I wouldn't create two same habits
//  Basically when displaying habit rows, detail views, edit sheets, etc.
//  I pass habits StateObject and current instance of Habit and then get the first index of that Habit, so
//  if you have 2 same habits, they will.. Oh wait I guess it's not true since each habit has a unique ID.
//  But I never tested it so be careful heh.
//

import SwiftUI

struct ContentView: View {
    @StateObject var habits = Habits()
    
    @State private var isNewHabitSheetOpen = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Button {
                    // open sheet
                    isNewHabitSheetOpen = true
                } label: {
                    Label("Add new habit", systemImage: "plus")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.bordered)
                .tint(.accentColor)
                .sheet(isPresented: $isNewHabitSheetOpen) {
                    NewHabit(habits: habits)
                }
                
                if habits.items.count > 0 {
                    List {
                        ForEach(habits.items) { habit in
                            NavigationLink {
                                // habit detail view
                                HabitDetailView(habits: habits, habit: habit)
                            } label: {
                                // list row
                                HabitRow(habits: habits, habit: habit)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init())
                            
                        }
                        .onMove(perform: move)

                    }
                    .listStyle(.plain)
                    
                    VStack(spacing: 10) {
                        Text("Today you have completed")
                            .foregroundColor(.gray)
                        Text("0")
                            .foregroundColor(.accentColor)
                            .font(.largeTitle)
                        Text("habits")
                            .foregroundColor(.gray)
                    }
                } else {
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Image(systemName: "tray")
                            .font(.largeTitle)
                        Text("You have 0 habits")
                        Text("click to get started")

                    }.foregroundColor(.gray)
                    
                    Spacer()
                }
                
                
            }
            .padding(.horizontal)
        
            .toolbar {
                // list edit button
                EditButton()
            }
            .navigationTitle("Habits")
        }
    }
    
    // move habits order in the list
    func move(from source: IndexSet, to destination: Int) {
        habits.items.move(fromOffsets: source, toOffset: destination)
    }
    
}

struct HabitIcon: View {
    
    var icon: String
    var color: String
    
    // convert color strings ("blue", etc.) into Color class
    var theme: Color {
        switch color {
            case "blue":
                return Color.blue
            case "red":
                return Color.red
            case "green":
                return Color.green
            case "yellow":
                return Color.yellow
            case "brown":
                return Color.brown
            case "cyan":
                return Color.cyan
            case "indigo":
                return Color.indigo
            case "mint":
                return Color.mint
            case "orange":
                return Color.orange
            case "pink":
                return Color.pink
            case "purple":
                return Color.purple
            case "teal":
                return Color.teal
            case "black":
                return Color.black
            case "gray":
                return Color.gray
            default:
                return Color.blue
        }
    }
    
    var body: some View {
        Image(systemName: icon)
            .foregroundColor(theme)
            .overlay(
                Circle()
                    .strokeBorder(theme, lineWidth: 2)
                    .frame(width: 40, height: 40)
            )
            .frame(width: 40, height: 40)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
