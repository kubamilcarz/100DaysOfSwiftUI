//
//  ContentView.swift
//  iExpense
//
//  Created by Kuba Milcarz on 23/11/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()

    @State private var showingAddExpense = false
    
    @State var businessExpenses = [ExpenseItem]()
    @State var personalExpenses = [ExpenseItem]()
    
    var body: some View {
        NavigationView {
            List {
                Section("Business") {
                    ForEach(businessExpenses) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                                .foregroundColor(item.amount < 10.0 ? .green : item.amount >= 10 && item.amount < 100 ? .yellow : .red)
                        }
                    }.onDelete(perform: removeItems)
                }
                
                Section("Personal") {
                    ForEach(personalExpenses) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                                .foregroundColor(item.amount < 10.0 ? .green : item.amount >= 10 && item.amount < 100 ? .yellow : .red)
                        }
                    }.onDelete(perform: removeItems)
                }
            }.listStyle(.sidebar)
                .refreshable { refreshData() }
            
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddExpense = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            
            .navigationTitle("iExpense")
        }
        .onAppear(perform: refreshData)
    }
    
    func refreshData() {
        businessExpenses = expenses.items.filter { $0.type == "Business" }
        personalExpenses = expenses.items.filter { $0.type == "Personal" }
    }
    
    func formatDate(_ date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "MMM dd, yyyy"
        return format.string(from: date)
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
        refreshData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
