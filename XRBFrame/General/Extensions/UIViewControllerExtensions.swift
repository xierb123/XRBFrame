//
//  UIViewControllerExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

// MARK: - Properties
extension UIViewController {
    /// Returns the previous controller
    var previousViewController: UIViewController? {
        if let viewControllers = navigationController?.viewControllers {
            let index = viewControllers.count - 2
            if index >= 0 {
                return viewControllers[index]
            }
        }
        return nil
    }
    
    /// Returns whether the modal view controller on the current navigation is visible
    var isVisible: Bool {
        guard let navigationController = Main.currentNavigationController else {
            return false
        }
        guard let visibleVC = navigationController.visibleViewController else {
            return false
        }
        return visibleVC == self
    }
    
    /// Returns whether the first view controller for navigation
    var isFirstOfNavigation: Bool {
        guard let firstVC = navigationController?.viewControllers.first else {
            return false
        }
        return firstVC == self
    }
}

// MARK: - Methods
extension UIViewController {
    /// Adds an NotificationCenter with name and Selector
    func addNotificationObserver(_ name: String, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    func addNotificationObserver(_ name: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }

    /// Removes an NSNotificationCenter for name
    func removeNotificationObserver(_ name: String) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    func removeNotificationObserver(_ name: NSNotification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }

    /// Removes NotificationCenter'd observer
    func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    // Dismisses keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// Pushes a view controller onto the receiver’s stack and updates the display.
    func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Pops the top view controller from the navigation stack and updates the display.
    func popVC() {
        navigationController?.popViewController(animated: true)
    }

    /// Added extension for popToRootViewController
    func popToRootVC() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    /// Presents a view controller modally.
    func presentVC(_ vc: UIViewController, completion: (() -> Void)? = nil) {
        present(vc, animated: true, completion: completion)
    }
    
    /// Dismisses the view controller that was presented modally by the view controller.
    func dismissVC(completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: completion)
    }
    
    /// Dismisses the view controller that was presented modally by the root view controller.
    func dismissToRootVC(animated: Bool = true, completion: (() -> Void)? = nil) {
        var rootVC = presentingViewController
        while let presentingVC = rootVC?.presentingViewController {
            rootVC = presentingVC
        }
        rootVC?.dismiss(animated: animated, completion: completion)
    }
    
    /// Helper method to add a UIViewController as a childViewController.
    ///
    /// - Parameters:
    ///   - child: the view controller to add as a child
    ///   - containerView: the containerView for the child viewcontroller's root view.
    func addChildViewController(_ child: UIViewController, toContainerView containerView: UIView) {
        addChild(child)
        containerView.addSubview(child.view)
        child.didMove(toParent: self)
    }

    /// Helper method to remove a UIViewController from its parent.
    func removeViewAndControllerFromParentViewController() {
        guard parent != nil else { return }

        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
