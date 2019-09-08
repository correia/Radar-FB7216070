//
//  SceneDelegate.swift
//  Gallery
//
//  Copyright © 2019 Apple, Inc. All rights reserved.
//

/*
See LICENSE folder for this sample’s licensing information.

Abstract:
This class demonstrates how to use the scene delegate to configure a scene's interface.
 It also implements basic state restoration.
*/

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    // UIWindowScene delegate
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity {
            if !configure(window: window, with: userActivity) {
                print("Failed to restore from \(userActivity)")
            }
        }

        // If there were no user activities, we don't have to do anything.
        // The `window` property will automatically be loaded with the storyboard's initial view controller.
    }
  
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity
    }
    
    /// The documentation for UIApplication.requestSceneSessionRefresh(_:) says:
    ///
    ///     Call this method when your scene is in the background and any
    ///     part of your scene's visible appearance changes. For example,
    ///     call this method after updating your scene's content to let the
    ///     system know your scene's snapshot requires refreshing. You don't
    ///     need to call this method when your scene is running in the
    ///     foreground.
    ///
    /// The code in sceneWillResignActive(_:) simulates sync data coming in
    /// to the application in way that requires the user interface to
    /// update.
    ///
    /// If this event happens anytime after sceneWillResignActive(_:), but
    /// before the scene has fully transitioned into the background, the
    /// scene's window gets into a weird state where the snapshot is
    /// blank/black. Bringing the scene to the foreground leaves it in this
    /// unusable state, but switching back to the Home screen, then back
    /// into the scene usually fixes it. Forcing the window to hidden then
    /// visible also seems to "fix" it.
    ///
    /// I may have high expectations, but I expect to be able to call
    /// requestSceneSessionRefresh(_:) in any scene state, and have UIKit:
    ///
    ///   - ignore requests made in the foreground state
    ///   - efficiently handle requests made in other states (coalescing if required)
    ///   - not "corrupt" the window and leave it in an unusable state
    ///
    /// The last is really the big issue, though, at this point.
    ///
    /// The workaround is to not issue the request refresh unless the scene
    /// is fully in the .background state.
    
    func sceneWillResignActive(_ scene: UIScene) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            debugPrint("Scene activation state is \(scene.activationState.rawValue).")
            
            switch scene.activationState {
            case .unattached, .foregroundActive:
                debugPrint("Skipping request refresh based on scene state.")
                break
                
            case .foregroundInactive, .background:
                debugPrint("Requesting scene scession refresh.")
                UIApplication.shared.requestSceneSessionRefresh(scene.session)
                
            @unknown default:
                debugPrint("Skipping request refresh; unknown future state.")
            }
        }
    }

    // Utilities
    
    func configure(window: UIWindow?, with activity: NSUserActivity) -> Bool {
        if activity.title == GalleryOpenDetailPath {
            if let photoID = activity.userInfo?[GalleryOpenDetailPhotoIdKey] as? String {
                
                if let photoDetailViewController = PhotoDetailViewController.loadFromStoryboard() {
                    photoDetailViewController.photo = Photo(name: photoID)
                    
                    if let navigationController = window?.rootViewController as? UINavigationController {
                        navigationController.pushViewController(photoDetailViewController, animated: false)
                        return true
                    }
                }
            }
        }
        return false
    }

}
