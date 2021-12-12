//
//  EditHabit.swift
//  Habits Tracker
//
//  Created by Kuba Milcarz on 29/11/2021.
//
//  THIS IS A SHEET VIEW
//

import SwiftUI

struct EditHabit: View {
    @ObservedObject var habits: Habits
    @Environment(\.dismiss) var dismiss // dimiss the sheet
    let index: Int
    
    // custom init to get index of the passed habit to operate further on habits.items[index] and not on a copy
    init(habits: Habits, habit: Habit) {
        self.habits = habits

        guard let i = habits.items.firstIndex(of: habit) else {
            fatalError("Error! This habit does not exist.")
        }
        
        index = i
    }
    
    // alert stuff
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isPresented = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading) {
                        Text("Pick the icon")
                            .font(.headline)
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
                                ForEach(Habits.HabitIcons, id: \.self) { icn in
                                    Button {
                                        // choose icon
                                        habits.items[index].icon = icn
                                    } label: {
                                        Image(systemName: icn).frame(width: 50, height: 50)
                                    }.foregroundColor(icn == habits.items[index].icon ? .accentColor : .gray)
                                }
                            }
                        }.frame(maxHeight: 260)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Pick accent color")
                            .font(.headline)
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 30))]) {
                            ForEach(Habits.HabitColors, id: \.self) { clr in
                                Button {
                                    chooseColor(clr)
                                } label: {
                                    clr
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }
                    
                    Section {
                        HStack(spacing: 10) {
                            HabitIcon(icon: habits.items[index].icon, color: habits.items[index].theme)
                            VStack(alignment: .leading) {
                                TextField("Name", text: $habits.items[index].name)
                                    .font(.headline)
                                TextField("Description", text: $habits.items[index].description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(.thickMaterial))
                        .padding(.vertical, 5)
                    }
                    
                    Spacer()
                }.padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveItem()
                    }
                    .alert(alertTitle, isPresented: $isPresented) {
                        Button("Ok") { }
                    } message: {
                        Text(alertMessage)
                    }
                }
            }
            .navigationTitle("Edit \(habits.items[index].name) habit")
        }
    }
    
    func saveItem() {
        // I guess this here is pretty useless since the data is automatically being updated on the go
        
        // let item = Habit(icon: icon, theme: color, name: name, description: description)
        // habits.items.insert(item, at: 0)
        dismiss()
    }
    
    func chooseColor(_ clr: Color) {
        var color = ""
        
        switch clr {
            case .blue:
                color = "blue"
            case .red:
                color = "red"
            case .green:
                color = "green"
            case .yellow:
                color = "yellow"
            case .brown:
                color = "brown"
            case .cyan:
                color = "cyan"
            case .indigo:
                color = "indigo"
            case .mint:
                color = "mint"
            case .orange:
                color = "orange"
            case .pink:
                color = "pink"
            case .purple:
                color = "purple"
            case .teal:
                color = "teal"
            case .black:
                color = "black"
            case .gray:
                color = "gray"
            default:
                color = "blue"
        }
        // update original color with String data which was converted from Color class above
        habits.items[index].theme = color
    }
}

struct EditHabit_Previews: PreviewProvider {
    static var previews: some View {
        EditHabit(habits: Habits(), habit: Habits().items[0])
    }
}
