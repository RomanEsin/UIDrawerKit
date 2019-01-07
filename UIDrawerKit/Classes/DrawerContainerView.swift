//
//  UIDrawerView.swift
//  UIDrawer
//
//  Created by Roman Esin on 28/12/2018.
//  Copyright © 2018 Mariya Esina. All rights reserved.
//

import UIKit

/// A Subclass of UIView responsible for presenting UIDrawer to view
/// of any size.
///
/// To present your custom ViewController inside of UIDrawer
/// use *present(_ viewController: UIViewController)*.
/// Your ViewController will be presented with cross dissolve animation.
///
/// - Important:
///     To add to your view use
/// *addContainerSubview(_ container: UIView, toController vc: UIViewController)*
/// method of your UIView, so the UIDrawer will know
/// the viewController that is presenting it.
///
/// - Author:
///     Roman Esin
public class UIDrawerView: UIView {
    /// Delegate that responds to Pan Gestures
//    public var delegate: UIDrawerViewDelegate?
    
    private enum State: CGFloat {
        case expanded = 450
        case compressed = 1000
    }
    
    // Animation
    private var state = State.expanded
    private var initOffset = CGPoint.zero
    private var animator = UIViewPropertyAnimator()
    
    // ViewControllers
    private var rootViewController: UIDrawerViewController!
    public weak var superViewController: UIViewController?
    
    // Constraints
    private var topConstraint: NSLayoutConstraint!
    private var leadingConstraing: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    private var widthConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!
    
    public override func didMoveToSuperview() {
        setupGR()
        
        layer.cornerRadius = 16
        dropShadow(shadowRadius: 8, opacity: 0.2)
        
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        rootViewController = UIDrawerViewController()
        topConstraint = topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor)
        leadingConstraing = leadingAnchor.constraint(equalTo: superview.leadingAnchor)
        trailingConstraint = trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        bottomConstraint = bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        
        NSLayoutConstraint.activate([
            topConstraint,
            leadingConstraing,
            trailingConstraint,
            bottomConstraint
            ])
        present(rootViewController!)
        
        superview.setNeedsLayout()
        superview.layoutIfNeeded()
        
        widthConstraint = widthAnchor.constraint(equalToConstant: frame.width)
        
        NSLayoutConstraint.activate([
            widthConstraint
            ])
        
        leadingConstraing.isActive = false
        trailingConstraint.isActive = false
    }
    
    private func setupGR() {
        let gr = UIPanGestureRecognizer(target: self, action: #selector(pan(recognizer:)))
        addGestureRecognizer(gr)
    }
    
    @objc private func pan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            let location = recognizer.location(in: superview)
            initOffset = CGPoint(x: location.x - center.x,
                                 y: location.y - center.y)
            topConstraint.isActive = false
            bottomConstraint.isActive = false
            
            heightConstraint = heightAnchor.constraint(equalToConstant: frame.height)
            NSLayoutConstraint.activate([
                heightConstraint
                ])
        case .changed:
            let location = recognizer.location(in: superview)
            center.y = location.y - initOffset.y
            
        case .ended, .failed, .cancelled:
            panEnded(recognizer)
            return
        default:
            return
        }
    }
    
    private func panEnded(_ recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocity(in: superview)
        let projectedPos = center.y + project(initialVelocity: velocity.y)
        var finalPos: CGFloat = 450
        var finalState = State.expanded
        
        switch projectedPos {
        case ...State.expanded.rawValue:
            finalState = .expanded
            state = .expanded
            
        case State.expanded.rawValue...State.compressed.rawValue:
            let full = CGFloat(abs(State.compressed.rawValue - State.expanded.rawValue))
            let pos = projectedPos - State.expanded.rawValue
            switch state {
            case .expanded:
                finalState =
                    (pos / full) >= 0.65 ? State.compressed : State.expanded
                
            case .compressed:
                finalState =
                    (pos / full) <= 0.35 ? State.expanded : State.compressed
                
            }
            
        case State.compressed.rawValue...:
            finalState = State.compressed
            state = .compressed
            
        default:
            finalState = .expanded
        }
        
        finalPos = finalState.rawValue
        
        let initialVelocity = CGVector(dx: 0,
                                       dy: relativeVelocity(forVelocity: abs(velocity.y),
                                                            from: center.x,
                                                            to: finalPos))
        let spring = UISpringTimingParameters(damping: 0.8,
                                              response: 0.4,
                                              initialVelocity: initialVelocity)
        animator = UIViewPropertyAnimator(duration: 0,
                                          timingParameters: spring)
        
        switch finalState {
        case .expanded:
            topConstraint =
                topAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.topAnchor)
            topConstraint.constant = 20
        case .compressed:
            topConstraint =
                topAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.bottomAnchor)
            topConstraint.constant = -90
        }
        
        topConstraint.isActive = true
        
        animator.addAnimations {
            self.superview?.layoutIfNeeded()
        }

        animator.startAnimation()
    }
    
    /// Presents a UIDrawerViewController for UIDrawerContainer,
    /// Should only be called once per UIDrawerContainer.
    ///
    /// - Parameter viewController: UIDrawerViewController that is going to be presented.
    private func present(_ viewController: UIDrawerViewController) {
        superViewController?.addChild(viewController)
        addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.setConstraints(relativeTo: self)
        viewController.didMove(toParent: superViewController)
    }
}

extension UIDrawerView {
    /// Calculates the relative velocity needed for the initial velocity of the animation.
    private func relativeVelocity(forVelocity velocity: CGFloat,
                                  from currentValue: CGFloat,
                                  to targetValue: CGFloat) -> CGFloat {
        guard currentValue - targetValue != 0 else { return 0 }
        return velocity / (targetValue - currentValue)
    }
    
    /// Distance traveled after decelerating to zero velocity at a constant rate.
    private func project(initialVelocity: CGFloat,
                         decelerationRate: CGFloat = UIScrollView.DecelerationRate.normal.rawValue) -> CGFloat {
        return (initialVelocity / 1000) * decelerationRate / (1 - decelerationRate)
    }
}

extension UIDrawerView {
    /// Presents a ViewController in UIDrawerView.
    ///
    /// - Parameter viewController: ViewController that is going to be presented
    public func present(_ viewController: UIViewController) {
        rootViewController.viewController = viewController
    }
}
