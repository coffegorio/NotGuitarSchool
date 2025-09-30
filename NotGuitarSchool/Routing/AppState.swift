//
//  AppState.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import Foundation

class AppState {
    static let shared = AppState()
    
    var currentRoute: AppRoute = .splash {
        didSet {
            onRouteChanged?(currentRoute)
        }
    }
    
    var onRouteChanged: ((AppRoute) -> Void)?
    
    private init() {}
}
