//
//  ViewController.swift
//  YelpRBC
//
//  Created by Chandra Sekhar Ravi on 10/02/21.
//

import UIKit

class RestaurantsViewController: UIViewController {
    //MARK:- Properties
    private var restaurantsViewModel : RestaurantsViewModel!
    
    @IBOutlet weak var restaurantCollectionView:UICollectionView!
    
    lazy var searchBar:UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
    lazy var activityIndicator:UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        //Add a title
        self.title = NSLocalizedString("Restaurants", comment: "Restaurants")
        
        //Add activity indicator to navigation bar
        let refreshBarButton: UIBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.rightBarButtonItem = refreshBarButton
        
        //Add a search bar
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self
    
        getRestaurantsList()
    }
    
    func getRestaurantsList(){
        //Initialise
        restaurantsViewModel = RestaurantsViewModel()
        
        //get the loading status from view model
        restaurantsViewModel.getLoadingStatus = {[weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading == true{
                    self?.activityIndicator.startAnimating()
                }else{
                    self?.activityIndicator.stopAnimating()
                }
            }
    }
        
        //get the list of restaurants and show in a colelctionView
        restaurantsViewModel.getrestaurantsDataClosure = {
            //make uirelated changes in the main thread
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.restaurantCollectionView.reloadData()
            }
        }
        
        //Handle error messages. Show an alert if there is any error message
        restaurantsViewModel.getErrorUpdate = {[weak self] error in
            DispatchQueue.main.async {
                self?.showErrorWithMessage(message: error.localizedDescription)
            }
        }
    }
    
    //Navigation
    //Instantiate the detail view controller and pass the data
    @IBSegueAction
      private func showRestaurantDetail(coder: NSCoder, sender: Any?, segueIdentifier: String?)
          -> RestaurantDetailViewController? {
        let index = sender as! Int
        return RestaurantDetailViewController(coder: coder, restaurantId: restaurantsViewModel.getRestaurantId(index))
      }


}



extension RestaurantsViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantsViewModel.numberOfRestaurants
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.kRestaurantCellId, for: indexPath) as! RestaurantCell
        cell.restaurant = restaurantsViewModel.getRestaurantAtIndex(indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.Segues.kShowRestaurantDetailSegue, sender: indexPath.item)
    }
    
}



extension RestaurantsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 20) / 2.0
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

}


extension RestaurantsViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        restaurantsViewModel.searchForRestaurant(restaurant: searchBar.text ?? "")
    }
        
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
}
