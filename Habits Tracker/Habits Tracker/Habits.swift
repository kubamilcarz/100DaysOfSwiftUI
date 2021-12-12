//
//  Habits.swift
//  Habits Tracker
//
//  Created by Kuba Milcarz on 29/11/2021.
//

import Foundation
import SwiftUI

class Habits: ObservableObject {
    @Published var items = [Habit]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Habits")
            }
        }
    }
    
    static let HabitIcons = ["tray.fill", "book.closed.fill", "face.smiling", "pencil", "bed.double.fill", "alarm", "heart.fill", "car.fill", "figure.walk", "bicycle", "gamecontroller.fill", "paintbrush.pointed.fill", "creditcard.fill", "bag.fill", "sun.max", "moon.fill", "phone.fill", "video.fill", "waveform", "keyboard", "display", "headphones", "earbuds", "tv", "eye", "eyes", "figure.wave", "staroflife", "ear", "pills.fill", "bandage.fill", "flag.fill", "pianokeys", "guitars.fill", "chevron.left.forwardslash.chevron.right", "drop.fill", "pawprint.fill", "leaf.fill", "person.3.fill", "person.crop.rectangle.stack.fill", "lungs", "figure.stand.line.dotted.figure.stand", "hand.thumbsup", "hand.thumbsdown", "hands.clap", "highlighter", "archivebox", "newspaper.fill", "graduationcap.fill", "umbrella.fill", "music.mic", "bell.fill", "scissors", "wrench.fill", "hammer.fill", "screwdriver.fill", "theatermasks.fill", "key.fill", "radio.fill", "film", "cup.and.saucer.fill", "takeoutbag.and.cup.and.straw.fill", "fork.knife", "studentdesk", "lightbulb.fill"]
    static let HabitColors: [Color] = [.blue, .red, .green, .yellow, .brown, .cyan, .indigo, .mint, .orange, .pink, .purple, .teal, .black, .gray]
    
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Habits") {
            if let decodedItems = try? JSONDecoder().decode([Habit].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct Habit: Identifiable, Codable, Equatable {
    var id = UUID()
    var icon: String
    var theme: String
    var name: String
    var description: String
    var isCompleted = false
}
