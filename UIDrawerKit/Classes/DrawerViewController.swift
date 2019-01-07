//
//  UIDrawerViewController.swift
//  UIDrawer
//
//  Created by Roman Esin on 26/12/2018.
//  Copyright © 2018 Mariya Esina. All rights reserved.
//

import UIKit

public typealias LayoutConstraint = NSLayoutConstraint

public class UIDrawerViewController: UIViewController {
    
    private var dragView: UIView!
    private var insideView: UIView!
    private var backgroundView: UIVisualEffectView!
    private var searchBar: UISearchBar!
    
    /// A View Controller that lies inside of UIDrawer.
    public var viewController: UIViewController? {
        didSet {
            guard let insideViewController = viewController else {
                UIView.animate(withDuration: 0.3, delay: 0,
                               options: .curveEaseOut, animations: {
                    oldValue?.view.alpha = 0
                })
                return
            }
            insideViewController.view.alpha = 0
            if !children.isEmpty {
                UIView.animate(withDuration: 0.3, delay: 0,
                               options: .curveEaseOut, animations: {
                    oldValue?.view.alpha = 0
                }, completion: { (_) in
                    oldValue?.removeFromParent()
                    oldValue?.view.removeFromSuperview()

                    self.createInsideVC(insideViewController)
                    UIView.animate(withDuration: 0.3, delay: 0,
                                   options: .curveEaseOut, animations: {
                        insideViewController.view.alpha = 1
                    })
                })
            } else {
                createInsideVC(insideViewController)
                UIView.animate(withDuration: 0.3, delay: 0,
                               options: .curveEaseOut, animations: {
                    insideViewController.view.alpha = 1
                })
            }
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        accessibilityLabel = "UIDrawer"
        
        setupBackground()
        setupDragView()
//        setupSearchBar()
        setupInsideView()
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal

        view.addSubview(searchBar)

        LayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: dragView.bottomAnchor, constant: 6),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    private func setupBackground() {
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.backgroundColor = .clear
        
        backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        backgroundView.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        backgroundView.setConstraints(relativeTo: view)
    }
    
    private func setupDragView() {
        dragView = UIView()
        dragView.accessibilityIdentifier = "dragView"
        dragView.translatesAutoresizingMaskIntoConstraints = false
        dragView.backgroundColor = .lightGray
        dragView.layer.cornerRadius = 3
        view.addSubview(dragView)
        
        LayoutConstraint.activate([
            dragView.topAnchor.constraint(equalTo: view.topAnchor, constant: 6),
            dragView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            dragView.heightAnchor.constraint(equalToConstant: 6),
            dragView.widthAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    private func setupInsideView() {
        insideView = UIView()
        insideView.translatesAutoresizingMaskIntoConstraints = false
        insideView.backgroundColor = .white
        insideView.layer.cornerRadius = 0
        insideView.clipsToBounds = true
        view.addSubview(insideView)
        
        LayoutConstraint.activate([
            insideView.topAnchor.constraint(equalTo: dragView.bottomAnchor, constant: 6),
//            insideView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            insideView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            insideView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            insideView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    private func createInsideVC(_ vc: UIViewController) {
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.frame = insideView.frame
        insideView.addSubview(vc.view)
        
        vc.view.setConstraints(relativeTo: insideView)
        vc.didMove(toParent: self)
    }
    
    override public func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
    }
}
