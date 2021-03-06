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
        let endpoints = DefaultFilmsEnpdoints()
        window?.windowScene = windowScene
        let tabBarVC = UITabBarController()
        tabBarVC.tabBar.tintColor = .black
        
        let firstVC = createTab(title: "Home", image: "house", controller: MainViewController(presenter: MainPresenter(dataTransferService: dataTransferService, endpoints: endpoints)))
        let secondVC = createTab(title: "Favourite", image: "star", controller: FavouriteController(presenter: FavouritePresenter(coreDataManager: CoreDataManager())))
    
        tabBarVC.setViewControllers([firstVC, secondVC], animated: false)
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
    }
    
    func createTab(title: String, image: String, controller: UIViewController) -> UINavigationController{
        let vc = controller
        let barItem = UITabBarItem()
        barItem.image = UIImage(systemName: image)
        barItem.title = title
        vc.tabBarItem = barItem
        let navigationVC = UINavigationController(rootViewController: vc)
        return navigationVC
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

