//
//  ContentView.swift
//  ConvertMe
//
//  Created by Kuba Milcarz on 12/11/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var inputValue: Double = 0
    @FocusState private var inputIsFocused: Bool
    
    @State private var inputUnit = "kilometers"
    @State private var outputUnit = "miles"
    
    let units = ["meters", "kilometers", "feet", "yards", "miles"]
    
    var convertedValue: Double {
        var input: Double = inputValue
        switch inputUnit {
            case "meters":
                break
            case "kilometers":
                input = inputValue * 1000
            case "feet":
                input = inputValue * 0.3048
            case "yards":
                input = inputValue * 0.9144
            case "miles":
                input = inputValue * 1609.344
            default: // assume user entered meters
                break
        }
        // input in meters, so convert meters to the output unit
        
        switch outputUnit {
            case "meters":
                return input
            case "kilometers":
                return input / 1000
            case "feet":
                return input * 3.2808398950131
            case "yards":
                return input * 1.0936132983377
            case "miles":
                return input / 1609.344
            default: // assume user entered meters
                return input
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        TextField("Type \(inputUnit)", value: $inputValue, format: .number)
                            .keyboardType(.decimalPad)
                            .focused($inputIsFocused)
                        Text(inputUnit)
                    }
                    
                } header: {
                    Text("Type Number")
                }
                
                Section {
                    Picker("Convert from", selection: $inputUnit) {
                        ForEach (units, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.automatic)
                    Picker("Convert to", selection: $outputUnit) {
                        ForEach (units, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.automatic)
                }
                
                Section {
                    Text(convertedValue.formatted())
                        .font(.largeTitle)
                        .foregroundColor(Color.accentColor)
                        .padding()
                }
                
            }
            .navigationTitle("ConvertMe")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        inputIsFocused = false
                    }
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
