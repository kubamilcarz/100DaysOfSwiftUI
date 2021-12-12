//
//  AddView.swift
//  iExpense
//
//  Created by Kuba Milcarz on 24/11/2021.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var expenses: Expenses
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var date = Date.now
    
    let types = ["Business", "Personal"]
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isPresented = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                Section {
                    TextField("Amount", value: $amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .keyboardType(.decimalPad)
                }
            }
            .toolbar {
                Button("Save") {
                    saveItem()
                }
                .alert(alertTitle, isPresented: $isPresented) {
                    Button("Ok") { }
                } message: {
                    Text(alertMessage)
                }
            }
            .navigationTitle("Add new expense")
        }
    }
    
    func saveItem() {
        if amount <= 0.0 {
            alertTitle = "Error"
            alertMessage = "Amount should be bigger than 0..."
            isPresented = true
            return
        }
        if name == "" {
            alertTitle = "Error"
            alertMessage = "An expense should have a name..."
            isPresented = true
            return
        }
        if date > Date.now {
            alertTitle = "Error"
            alertMessage = "You couldn't have possibly purchased something in the future..."
            isPresented = true
            return
        }
        
        
        let item = ExpenseItem(name: name, type: type, amount: amount, date: date)
        expenses.items.insert(item, at: 0)
        dismiss()
    }
    
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
