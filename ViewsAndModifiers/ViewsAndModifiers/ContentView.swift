//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Kuba Milcarz on 14/11/2021.
//

import SwiftUI

struct ContentView: View {
    
    @ViewBuilder var houses: some View {
        Text("Gryffindor")
        Text("Hufflepuff")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Title")
                .hugeTitleStyle()
            Text("Custom modifiers can do much more than just apply other existing modifiers – they can also create new view structure, as needed. Remember, modifiers return new objects rather than modifying existing ones, so we could create one that embeds the view in a stack and adds another view:")
            Text("Tip: Often folks wonder when it’s better to add a custom view modifier versus just adding a new method to View, and really it comes down to one main reason: custom view modifiers can have their own stored properties, whereas extensions to View cannot.")
            Spacer()
        }
        .frame(width: 300, height: 600)
        .padding()
        .background(.regularMaterial)
        
    }
}

extension View {
    func hugeTitleStyle() -> some View {
        modifier(HugeTitle())
    }
}

struct HugeTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical)
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
