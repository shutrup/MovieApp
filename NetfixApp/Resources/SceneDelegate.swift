//
//  SceneDelegate.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 02.08.2022.
//

import UIKit
import FirebaseAuth
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        
        if let user = Auth.auth().currentUser {
            FirestoreService.shared.getUserData(user: user) { result in
                switch result {
                case .success(let users):
                    self.window?.rootViewController = MainTabBarVC(current: users)
                case .failure(let error):
                    self.window?.rootViewController = AuthVC()
                    print(error)
                }
            }
        }else {
            window?.rootViewController = AuthVC()
        }
       
        window?.makeKeyAndVisible()
    }

}

