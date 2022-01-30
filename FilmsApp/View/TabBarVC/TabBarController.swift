import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataTransferService = DefaultDataTransferService(config: NetworkConfig(server:  Server(scheme: .https, host: "imdb-api.com")))
        let endpoints = DefaultMoviesEnpdoints()
        let homeVC = MainViewController(presenter: MainPresenter(dataTransferService: dataTransferService, endpoints: endpoints))
        let favouriteVC = FavouriteController(presenter: FavouritePresenter())
        
        homeVC.title = "Home"
        favouriteVC.title = "Favourite"
        
        let firstVC = UINavigationController(rootViewController: homeVC)
        let secondVC = UINavigationController(rootViewController: favouriteVC)
        
        self.setViewControllers([firstVC, secondVC], animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        let images = ["house", "star"]
        
        for x in 0...1 {
            items[x].image = UIImage(systemName: images[x])
        }
        
        self.tabBar.tintColor = .black
    }
}
