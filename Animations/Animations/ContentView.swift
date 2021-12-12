//
//  ContentView.swift
//  Animations
//
//  Created by Kuba Milcarz on 20/11/2021.
//

import SwiftUI

struct ContentView: View {
    
//    let gradient = LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
//    let letters = Array("Hello World")
//
//    @State private var enabled = false
//
//    @State private var dragAmount = CGSize.zero
    
    @State private var isShowingRed = false
        
    var body: some View {
// MARK – gestures, follow finger
//        HStack(spacing: 0) {
//            ForEach(0..<letters.count) { num in
//                Text(String(letters[num]))
//                    .padding(5)
//                    .font(.title)
//                    .background(enabled ? .blue : .red)
//                    .background(Capsule())
//                    .offset(dragAmount)
//                    .animation(.default.delay(Double(num) / 20), value: dragAmount)
//            }
//        }
//        .gesture(
//            DragGesture()
//                .onChanged { dragAmount = $0.translation }
//                .onEnded { _ in
//                    dragAmount = .zero
//                    enabled.toggle()
//                }
//        )
        
// MARK - toggling views with animations
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)

            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
//                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
                    .transition(.asymmetric(insertion: .pivot, removal: .slide))
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
        }
// MARK – CUSTOM TRANSITIONS USING VIEWMODIFIER
//        VStack {
//
//        }
    }
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
