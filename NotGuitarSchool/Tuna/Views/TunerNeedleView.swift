//
//  TunerNeedleView.swift
//  NotGuitarSchool
//

import UIKit

final class TunerNeedleView: UIView {

    var deviationHz: CGFloat = 0 {
        didSet { updateNeedle(animated: true) }
    }
    var rangeHz: CGFloat = 10

    private let fullScaleAngle: CGFloat = .pi / 4
    private let needleLayer = CAShapeLayer()
    private let centerDot = CAShapeLayer()
    private let tickLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear
        tickLayer.strokeColor = UIColor.secondaryLabel.cgColor
        tickLayer.fillColor = UIColor.clear.cgColor
        tickLayer.lineWidth = 1
        layer.addSublayer(tickLayer)

        needleLayer.strokeColor = UIColor.label.cgColor
        needleLayer.fillColor = UIColor.clear.cgColor
        needleLayer.lineWidth = 3
        needleLayer.lineCap = .round
        layer.addSublayer(needleLayer)

        centerDot.fillColor = UIColor.label.cgColor
        layer.addSublayer(centerDot)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let bounds = self.bounds
        let center = CGPoint(x: bounds.midX, y: bounds.maxY - 6)
        let radius = min(bounds.width, bounds.height) * 0.46

        let ticksPath = UIBezierPath()
        let minorCount = 10
        for i in -minorCount...minorCount {
            let t = CGFloat(i) / CGFloat(minorCount)
            let angle = (.pi) - (t + 1) * (.pi / 2)
            let inner = CGPoint(
                x: center.x + cos(angle) * (radius - 10),
                y: center.y - sin(angle) * (radius - 10)
            )
            let outer = CGPoint(
                x: center.x + cos(angle) * (radius + 4),
                y: center.y - sin(angle) * (radius + 4)
            )
            ticksPath.move(to: inner)
            ticksPath.addLine(to: outer)
        }
        tickLayer.path = ticksPath.cgPath

        let needlePath = UIBezierPath()
        needlePath.move(to: center)
        needlePath.addLine(to: CGPoint(x: center.x, y: center.y - radius))
        needleLayer.path = needlePath.cgPath
        needleLayer.bounds = bounds
        needleLayer.position = center
        needleLayer.anchorPoint = CGPoint(x: 0.5, y: 1.0)

        let dotPath = UIBezierPath(ovalIn: CGRect(x: center.x - 3, y: center.y - 3, width: 6, height: 6))
        centerDot.path = dotPath.cgPath

        updateNeedle(animated: false)
    }

    private func updateNeedle(animated: Bool) {
        let clamped = max(-rangeHz, min(rangeHz, deviationHz))
        let normalized = clamped / rangeHz
        let angle = normalized * fullScaleAngle
        let rotation = CATransform3DMakeRotation(angle, 0, 0, 1)

        if animated {
            let anim = CABasicAnimation(keyPath: "transform")
            anim.fromValue = needleLayer.presentation()?.transform ?? needleLayer.transform
            anim.toValue = rotation
            anim.duration = 0.08
            anim.timingFunction = CAMediaTimingFunction(name: .easeOut)
            needleLayer.add(anim, forKey: "rotate")
        }
        needleLayer.transform = rotation
    }
}


