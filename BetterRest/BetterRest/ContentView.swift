//
//  ContentView.swift
//  BetterRest
//
//  Created by Kuba Milcarz on 16/11/2021.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    static var defualtWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var suggestedBedTime: String {
        return calculateBedtime()
    }
    
    // sleep parameters
    @State private var sleepAmount: Double = 8.0
    @State private var wakeUp = defualtWakeTime
    @State private var coffeeAmount: Int = 1

    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                } header: {
                    Text("When do you want to wake up?")
                }
                
                Section {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                } header: {
                    Text("Desired amount of sleep")
                }
                
                Section {
                    HStack {
                        Text("Number of cups of coffee")
                        Spacer()
                        Picker("Number of cups of coffee", selection: $coffeeAmount) {
                            Text("1 cup").tag(1)
                            ForEach (2..<21) {
                                Text("\($0) cups").tag($0)
                            }
                        }.pickerStyle(.menu)
                    }
                    
                } header: {
                    Text("Daily cofee intake")
                }
                
                Section {
                    Text(suggestedBedTime)
                        .frame(maxWidth: .infinity)
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                        .multilineTextAlignment(.center)
                        .padding()
                } header: {
                    Text("Suggested bedtime")
                }
                
            }
            .navigationTitle("BetterRest")
        }
    }
    
    func calculateBedtime() -> String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(
                wake: Double(hour + minute),
                estimatedSleep: sleepAmount,
                coffee: Double(coffeeAmount)
            )
            
            let sleepTime = wakeUp - prediction.actualSleep
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "An error occured. There was a problem calculating your bedtime."
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
