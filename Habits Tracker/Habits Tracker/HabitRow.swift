//
//  HabitRow.swift
//  Habits Tracker
//
//  Created by Kuba Milcarz on 30/11/2021.
//
//  Habit list row view
//

import SwiftUI

struct HabitRow: View {
    @ObservedObject var habits: Habits
    var habit: Habit
    
    var body: some View {
        HStack(spacing: 10) {
            HabitIcon(icon: habit.icon, color: habit.theme)
            VStack(alignment: .leading) {
                Text(habit.name)
                    .font(.headline)
                Group {
                    if habit.description != "" {
                        Text(habit.description)
                            .font(.subheadline).foregroundColor(.gray)
                    }
                }
                
            }
            Spacer()
            Image(systemName: habit.isCompleted ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
                .font(.title3)
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(.thickMaterial))
        .padding(.vertical, 5)
        .opacity(habit.isCompleted ? 0.5 : 1.0)
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            if habit.isCompleted {
                Button("Mark as undone") {
                    if let index = habits.items.firstIndex(of: habit) {
                        withAnimation {
                            habits.items[index].isCompleted = false
                        }
                    }
                }.tint(.red)
            } else {
                Button("Mark as done") {
                    if let index = habits.items.firstIndex(of: habit) {
                        withAnimation {
                            habits.items[index].isCompleted = true
                        }
                    }
                }.tint(.green)
            }
        }
    }
}

struct HabitRow_Previews: PreviewProvider {
    static var previews: some View {
        HabitRow(habits: Habits(), habit: Habits().items[0])
    }
}
