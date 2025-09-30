//
//  AppCoordinator.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit

class AppCoordinator {
    private let window: UIWindow
    private let state = AppState.shared
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        state.onRouteChanged = { [weak self] route in
            self?.handleRoute(route, animated: true)
        }
        handleRoute(state.currentRoute)
        window.makeKeyAndVisible()
    }
    
    private func handleRoute(_ route: AppRoute, animated: Bool = true) {
        let newRoot: UIViewController
        
        switch route {
        case .splash:
            newRoot = SplashViewController()
        case .auth:
            newRoot = AuthViewController(viewModel: AuthViewModel())
        case .main:
            newRoot = MainViewController()
        }
        
        guard animated else {
            window.rootViewController = newRoot
            return
        }
        
        let snapshot = window.snapshotView(afterScreenUpdates: true) ?? UIView()
        newRoot.view.addSubview(snapshot)
        
        window.rootViewController = newRoot
        
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            snapshot.alpha = 0
            snapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: { _ in
            snapshot.removeFromSuperview()
        })
    }
}
