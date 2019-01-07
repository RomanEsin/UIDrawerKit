//
//  UI Extensions.swift
//  UIDrawer
//
//  Created by Roman Esin on 28/12/2018.
//  Copyright © 2018 Mariya Esina. All rights reserved.
//

import UIKit

public extension UIView {
    public func setConstraints(top: CGFloat = 0,
                        leading: CGFloat = 0,
                        trailing: CGFloat = 0,
                        bottom: CGFloat = 0,
                        relativeTo view: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)
            ])
    }
    
    public func anchor(top: NSLayoutAnchor<NSLayoutYAxisAnchor>, inset i1: CGFloat = 0,
                       leading: NSLayoutAnchor<NSLayoutXAxisAnchor>, inset i2: CGFloat = 0,
                       trailing: NSLayoutAnchor<NSLayoutXAxisAnchor>, inset i3: CGFloat = 0,
                       bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>, inset i4: CGFloat = 0) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: top, constant: i1),
            leadingAnchor.constraint(equalTo: leading, constant: i2),
            trailingAnchor.constraint(equalTo: trailing, constant: i3),
            bottomAnchor.constraint(equalTo: bottom, constant: i4)
            ])
    }
}

public extension UIView {
    /// Method for presenting *UIDrawerView*.
    ///
    /// - Important:
    ///     Use on view that is presented on ViewController.
    /// - Parameters:
    ///   - container: A UIDrawerController that is going to be presented.
    ///   - viewController: ViewController that is responsible for handling.
    public func addContainerSubview(_ container: UIView, toController viewController: UIViewController) {
        self.addSubview(container)
        
        guard let container = container as? UIDrawerView else { return }
        container.superViewController = viewController
        container.present(UIDrawerViewController())
    }
}

public extension UIView {
    /// Makes UIView drop a shadow. You can specify its shadow radius and opacity.
    ///
    /// - Parameters:
    ///   - shadowRadius: Radius of the shadow beaing applied. Default value is 4
    ///   - opacity: Opacity of the shadow being applied. Default value is 0.25
    public func dropShadow(shadowRadius: CGFloat = 10, opacity: Float = 0.1) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    @discardableResult
    public func createGradientLayer(withColors colors: [UIColor]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.cgColors
        gradientLayer.frame = frame
        layer.addSublayer(gradientLayer)
        return gradientLayer
    }
    
    @discardableResult
    public func createGradientLayer(withColors colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.cgColors
        gradientLayer.frame = frame
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.addSublayer(gradientLayer)
        return gradientLayer
    }
}

public extension Array where Element: UIColor {
    public var cgColors: [CGColor] {
        return self.map { $0.cgColor }
    }
}
