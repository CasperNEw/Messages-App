//
//  GradientView.swift
//  Messages-App
//
//  Created by Дмитрий Константинов on 26.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class GradientView: UIView {

    private let gradientLayer = CAGradientLayer()

    enum Point {
        case topLeading, leading, bottomLeading
        case top, center, bottom
        case topTrailing, trailing, bottomTrailing

        var point: CGPoint {
            switch self {
            case .topLeading:
                return CGPoint(x: 0, y: 0)
            case .leading:
                return CGPoint(x: 0, y: 0.5)
            case .bottomLeading:
                return CGPoint(x: 0, y: 1)
            case .top:
                return CGPoint(x: 0.5, y: 0)
            case .center:
                return CGPoint(x: 0.5, y: 0.5)
            case .bottom:
                return CGPoint(x: 0.5, y: 1)
            case .topTrailing:
                return CGPoint(x: 1, y: 0)
            case .trailing:
                return CGPoint(x: 1, y: 0.5)
            case .bottomTrailing:
                return CGPoint(x: 1, y: 1)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(fromPoint: Point, toPoint: Point, startColor: UIColor?, endColor: UIColor?) {
        self.init()
        setupGradient(fromPoint: fromPoint, toPoint: toPoint, startColor: startColor, endColor: endColor)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private func setupGradient(fromPoint: Point, toPoint: Point, startColor: UIColor?, endColor: UIColor?) {
        self.layer.addSublayer(gradientLayer)
        setupGradientColors(startColor: startColor, endColor: endColor)
        gradientLayer.startPoint = fromPoint.point
        gradientLayer.endPoint = toPoint.point
    }

    private func setupGradientColors(startColor: UIColor?, endColor: UIColor?) {
        if let startColor = startColor, let endColor = endColor {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }

    // MARK: Implementation for IB
    @IBInspectable private var startColor: UIColor? {
        didSet {
            setupGradientColors(startColor: startColor, endColor: endColor)
        }
    }

    @IBInspectable private var endColor: UIColor? {
        didSet {
            setupGradientColors(startColor: startColor, endColor: endColor)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient(fromPoint: .leading, toPoint: .trailing, startColor: startColor, endColor: endColor)
    }

}
