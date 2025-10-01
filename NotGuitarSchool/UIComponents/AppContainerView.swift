//
//  AppContainerView.swift
//  NotGuitarSchool
//
//  Created by Assistant on 30.09.2025.
//

import UIKit

final class AppContainerView: UIView {
    
    private let containerColor: UIColor
    
    init(containerColor: UIColor) {
        self.containerColor = containerColor
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.containerColor = AppColors.componentsTextColor
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = containerColor
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
}
