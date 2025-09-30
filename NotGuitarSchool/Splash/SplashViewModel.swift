//
//  SplashViewModel.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import Foundation

class SplashViewModel {
    func startNextScreenTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            AppState.shared.currentRoute = .auth
        }
    }
    
    private func checkIsAuthed() {
        
    }
}
