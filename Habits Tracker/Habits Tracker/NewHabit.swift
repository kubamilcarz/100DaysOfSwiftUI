//
//  NewHabit.swift
//  Habits Tracker
//
//  Created by Kuba Milcarz on 29/11/2021.
//
//  THIS IS A SHEET VIEW
//

import SwiftUI

struct NewHabit: View {
    @ObservedObject var habits: Habits
    @Environment(\.dismiss) var dismiss // dimiss sheet
    
    @State private var name = ""
    @State private var icon = "headphones"
    @State private var description = ""
    @State private var color = "blue"
    
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
                            // lazy grid for SF icons
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
                                ForEach(Habits.HabitIcons, id: \.self) { icn in
                                    Button {
                                        // choose icon
                                        icon = icn
                                    } label: {
                                        Image(systemName: icn).frame(width: 50, height: 50)
                                    }.foregroundColor(icn == icon ? .accentColor : .gray)
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
                                    // convert color between Color and String
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
                            HabitIcon(icon: icon, color: color)
                            VStack(alignment: .leading) {
                                TextField("Name", text: $name)
                                    .font(.headline)
                                TextField("Description", text: $description)
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
                        Button("Ok") { /* dimiss modal automatically */ }
                    } message: {
                        Text(alertMessage)
                    }
                }
            }
            .navigationTitle("Add new habit")
        }
    }
    
    func saveItem() {
        if name == "" || name == " " {
            alertTitle = "Error"
            alertMessage = "Your new habit should have a name"
            isPresented = true
            return
        }
        
        // create a habit instance and push it into Habits() items published array at index 0
        let item = Habit(icon: icon, theme: color, name: name, description: description)
        habits.items.insert(item, at: 0)
        // dimiss sheet (I told you it was a sheet view)
        dismiss()
    }
    
    func chooseColor(_ clr: Color) {
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
    
    }
}

struct NewHabit_Previews: PreviewProvider {
    static var previews: some View {
        NewHabit(habits: Habits())
    }
}
