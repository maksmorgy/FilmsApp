//
//  SceneDelegate.swift
//  FilmsApp
//
//  Created by Максим Моргун on 06.12.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        let dataTransferService = DefaultDataTransferService(config: NetworkConfig(server:  Server(scheme: .https, host: "imdb-api.com")))
        let endpoints = DefaultMoviesEnpdoints()
        window?.windowScene = windowScene
        let mainVC = MainViewController(presenter: MainPresenter(dataTransferService: dataTransferService, endpoints: endpoints))
        let tabBarVC = UITabBarController()
        
        let homeVC = MainViewController(presenter: MainPresenter(dataTransferService: dataTransferService, endpoints: endpoints))
        let favouriteVC = FavouriteController(presenter: FavouritePresenter())
        
        let homeTabBarItem = UITabBarItem()
        let favouriteTabBarItem = UITabBarItem()
        homeTabBarItem.image = UIImage(systemName: "house")
        favouriteTabBarItem.image = UIImage(systemName: "star")
        homeTabBarItem.title = "Home"
        favouriteTabBarItem.title = "Favourite"
        tabBarVC.tabBar.tintColor = .black
    
        homeVC.tabBarItem = homeTabBarItem
        favouriteVC.tabBarItem = favouriteTabBarItem
        
        let firstVC = UINavigationController(rootViewController: homeVC)
        let secondVC = UINavigationController(rootViewController: favouriteVC)
        tabBarVC.setViewControllers([firstVC, secondVC], animated: false)
        
        let navVC = UINavigationController(rootViewController: mainVC)
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
        
        
        
        
//        func createTabBar() {
//
//            let homeVC = MainViewController(presenter: MainPresenter(dataTransferService: dataTransferService, endpoints: endpoints))
//            let favouriteVC = FavouriteController(presenter: FavouritePresenter())
//
//            homeVC.title = "Home"
//            favouriteVC.title = "Favourite"
//
//            let homeTabBarItem = UITabBarItem()
//            let favouriteTabBarItem = UITabBarItem()
//            homeTabBarItem.image = UIImage(systemName: "house")
//            favouriteTabBarItem.image = UIImage(systemName: "star")
//
//            homeVC.tabBarItem = homeTabBarItem
//            favouriteVC.tabBarItem = favouriteTabBarItem
//
//
//            let firstVC = UINavigationController(rootViewController: homeVC)
//            let secondVC = UINavigationController(rootViewController: favouriteVC)
//
//            self.setViewControllers([firstVC, secondVC], animated: false)
//
//
//
//
//        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
    }


}

