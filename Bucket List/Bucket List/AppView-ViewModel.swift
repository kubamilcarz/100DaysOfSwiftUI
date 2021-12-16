//
//  AppView-ViewModel.swift
//  Bucket List
//
//  Created by Kuba Milcarz on 16/12/2021.
//

import Foundation
import LocalAuthentication
import MapKit

extension AppView {
    @MainActor class ViewModel: ObservableObject {
        @Published var isUnlocked = false
        
        @Published private(set) var locations: [Location]
        @Published var selectedPlace: Location?
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 7), span: MKCoordinateSpan(latitudeDelta: 28, longitudeDelta: 28))
        @Published var showingSettingsSheet = false
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegion.center.latitude, longtitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace = selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticateError in
                    if success {
                        self.isUnlocked =  true
                    } else {
                        // error
                    }
                }
            } else {
                // no biometrics
            }
        }
    }
}

