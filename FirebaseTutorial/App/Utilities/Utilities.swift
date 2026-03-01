//
//  Utilities.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 09/02/2026.
//

import Foundation
import UIKit

final class Utilities {
    
    static let shared = Utilities()
    private init() {}
    
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller: UIViewController? = {
            if let controller = controller { return controller }
            // Prefer the key window of the active foreground scene (iOS 13+ multiple scenes)
            if let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) {
                if let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                    return keyWindow.rootViewController
                }
                // Fallback to any visible window in this scene
                if let anyWindow = windowScene.windows.first(where: { !$0.isHidden && $0.windowLevel == .normal }) {
                    return anyWindow.rootViewController
                }
            }
            // Global fallback across connected scenes without using deprecated UIApplication.shared.windows
            // Prefer a key window from any foreground-active scene
            if let anyKeyRoot = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .filter({ $0.activationState == .foregroundActive })
                .compactMap({ scene in scene.windows.first(where: { $0.isKeyWindow })?.rootViewController })
                .first {
                return anyKeyRoot
            }
            // Then try any visible normal-level window across any connected scene
            if let anyVisibleRoot = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { !$0.isHidden && $0.windowLevel == .normal })?
                .rootViewController {
                return anyVisibleRoot
            }
            return nil
        }()
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
