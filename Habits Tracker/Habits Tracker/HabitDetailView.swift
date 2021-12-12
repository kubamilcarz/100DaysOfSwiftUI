//
//  HabitDetailView.swift
//  Habits Tracker
//
//  Created by Kuba Milcarz on 29/11/2021.
//

import SwiftUI

struct HabitDetailView: View {
    @ObservedObject var habits: Habits
    let index: Int
    
    // custom init to get index of the passed habit to operate further on habits.items[index] and not on a copy
    init(habits: Habits, habit: Habit) {
        self.habits = habits
        
        guard let i = habits.items.firstIndex(of: habit) else {
            fatalError("Error! This habit does not exist.")
        }
        
        index = i
        
    }
    
    @State private var alertTitle = "Are you sure?"
    @State private var alertMessage = "This operation cannot be undone. What's deleted, is deleted."
    @State private var isPresented = false
    @State private var isEditSheetOpen = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                HabitRow(habits: habits, habit: habits.items[index])

                HStack(spacing: 10) {
                    Button {
                        withAnimation {
                            habits.items[index].isCompleted.toggle()
                        }
                    } label: {
                        Text(habits.items[index].isCompleted ? "Mark as undone" : "Mark as done")
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered).tint(habits.items[index].isCompleted ? .red : .green)
                    .frame(maxWidth: .infinity)
                    
                    Button(role: .destructive) {
                        isPresented = true
                    } label: {
                        Text("Delete Habit")
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent).tint(.red)
                    .frame(maxWidth: .infinity)
                    .alert(alertTitle, isPresented: $isPresented) {
                        Button("Cancel", role: .cancel) { }
                        Button("Proceed", role: .destructive) {
                            habits.items.removeAll { $0.id == habits.items[index].id }
                        }
                    } message: {
                        Text(alertMessage)
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Statistics").font(.headline)
                    Text("Current Streak: 8 days").foregroundColor(.accentColor)
                    Text("Longest Streak: 43 days")
                    Text("Numbers of Times Checked: 95 times")
                }
            }.padding(.horizontal)
        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    isEditSheetOpen = true
                }.sheet(isPresented: $isEditSheetOpen) {
                    EditHabit(habits: habits, habit: habits.items[index])
                }
            }
        }
        .navigationTitle(habits.items[index].name)
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailView(habits: Habits(), habit: Habits().items[0])
    }
}
