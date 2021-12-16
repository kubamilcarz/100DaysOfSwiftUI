//
//  AppView.swift
//  Bucket List
//
//  Created by Kuba Milcarz on 15/12/2021.
//

import MapKit
import SwiftUI

struct AppView: View {
    @StateObject private var viewModel = ViewModel()

    @Binding var isUnlocked: Bool

    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(Circle())
                        Text(location.name)
                            .fixedSize()
                    }.onTapGesture {
                        viewModel.selectedPlace = location
                    }
                }
            }
                .ignoresSafeArea()
            Circle()
                .fill(.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            VStack {
                HStack {
                    Button {
                        viewModel.showingSettingsSheet = true
                    } label: {
                        Image(systemName: "person.fill")
                    }
                    .padding()
                    .background(Color.white)
                    .overlay(Circle().stroke(Color.accentColor, lineWidth: 5))
                    .foregroundColor(Color.accentColor)
                    .clipShape(Circle())
                    .padding(.leading)
                    .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 0)
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        viewModel.addLocation()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                    .shadow(color: .black.opacity(0.7), radius: 20, x: 0, y: 0)
                }
            }
            .sheet(isPresented: $viewModel.showingSettingsSheet) {
                SettingsView(isUnlocked: $isUnlocked)
            }
        }
        .sheet(item: $viewModel.selectedPlace) { place in
            EditView(location: place) { newLocation in
                viewModel.update(location: newLocation)
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(isUnlocked: .constant(false))
    }
}
