//
//  AuthenticateView.swift
//  Bucket List
//
//  Created by Kuba Milcarz on 15/12/2021.
//

import LocalAuthentication
import SwiftUI

struct AuthenticateView: View {
    @Binding var isUnlocked: Bool
    
    @State private var didBiometricFail = false
    @State private var password = ""

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Image(systemName: "lock.fill")
                .font(.largeTitle)
            Spacer()
            VStack(alignment: .center, spacing: 30) {
                Text("Bucket List")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.accentColor)
                Text(didBiometricFail ? "Type your password to proceed." : "Use biometric authentication to proceed.")
                Group {
                    if didBiometricFail {
                        Spacer()
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(password.count < 1 ? .gray : .primary)
                            Image(systemName: "circle.fill")
                                .foregroundColor(password.count < 2 ? .gray : .primary)
                            Image(systemName: "circle.fill")
                                .foregroundColor(password.count < 3 ? .gray : .primary)
                            Image(systemName: "circle.fill")
                                .foregroundColor(password.count < 4 ? .gray : .primary)
                        }
                        Spacer()
                        VStack(spacing: 15) {
                            HStack(spacing: 15) {
                                PinButton(content: "1", password: $password)
                                PinButton(content: "2", password: $password)
                                PinButton(content: "3", password: $password)
                            }
                            HStack(spacing: 15) {
                                PinButton(content: "4", password: $password)
                                PinButton(content: "5", password: $password)
                                PinButton(content: "6", password: $password)
                            }
                            HStack(spacing: 15) {
                                PinButton(content: "7", password: $password)
                                PinButton(content: "8", password: $password)
                                PinButton(content: "9", password: $password)
                            }
                            PinButton(content: "0", password: $password)
                            Spacer()
                        }
                        .onChange(of: password) { pass in
                            if pass.count == 4 {
                                if pass == "4769" {
                                    isUnlocked = true
                                } else {
                                    password = ""
                                }
                            }
                        }
                    } else {
                        Spacer()
                        Image(systemName: "touchid")
                            .font(.system(size: 50))
                            .foregroundColor(.pink)
                    }
                }
            }
            .onAppear(perform: authenticate)
        }
        .padding()
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // we can use biometrics here :)
            let reason = "We need to unlock your data."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    // authenticated successfully
                    withAnimation {
                        isUnlocked = true
                    }
                } else {
                    // there was a problem
                    withAnimation {
                        didBiometricFail = true
                    }
                }
            }
        } else {
            // no biometrics
            withAnimation {
                didBiometricFail = true
            }
        }
    }
}

struct PinButton: View {
    var content: String
    
    @Binding var password: String
    
    var body: some View {
        Button {
            password += content
        } label: {
            Text(content)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.accentColor)
                .font(.title)
        }
        .frame(width: 80, height: 80)
        .clipShape(Circle())
        
    }
}

struct AuthenticateView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticateView(isUnlocked: .constant(false))
    }
}
