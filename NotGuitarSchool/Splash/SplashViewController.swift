//
//  SplashViewController.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    private var viewModel: SplashViewModel
    private var splashAnimationView: LottieAnimationView?
    
    init(viewModel: SplashViewModel = SplashViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        routeNextScreen()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.backgroundColor
        setupPreviewAnimation()
    }
    
    private func setupPreviewAnimation() {
        splashAnimationView = .init(name: "SplashViewAnimation")
        splashAnimationView?.frame = view.bounds
        splashAnimationView?.contentMode = .scaleAspectFit
        splashAnimationView?.loopMode = .loop
        splashAnimationView?.animationSpeed = 1
        view.addSubview(splashAnimationView!)
        splashAnimationView?.play()
    }
    
    private func routeNextScreen() {
        viewModel.startNextScreenTimer()
    }
}
