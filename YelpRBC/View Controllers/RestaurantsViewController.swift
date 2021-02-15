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

    
    //MARK:- IBOutlets
    @IBOutlet weak var restaurantCollectionView:UICollectionView!
    @IBOutlet weak var searchBar:UISearchBar!

    
    lazy var activityIndicator:UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.tintColor = .white
        activityIndicator.color = .white
        return activityIndicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //default setup
        setupUI()
        
      //get restaurants list
        getRestaurantsList()
    }
    
    
    func setupUI(){
                
        //Add a title
        self.title = NSLocalizedString("Restaurants", comment: "Restaurants")
        
        //Setup activity indicator and add as a right bar button item.
        let refreshBarButton: UIBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.rightBarButtonItem = refreshBarButton

        
        //Add a search bar
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.textColor = .white
        }
    }
    
  
    
    
    func getRestaurantsList(){
        self.activityIndicator.startAnimating()
      
        //Initialise
        restaurantsViewModel = RestaurantsViewModel()
        
        //get the list of restaurants and show in a colelctionView
        restaurantsViewModel.getrestaurantsDataClosure = {
            //make uirelated changes in the main thread
            DispatchQueue.main.async {
                if self.activityIndicator.isAnimating{
                    self.activityIndicator.stopAnimating()
                }
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
    
    //MARK:- Custom functions
    @IBAction  func showSortOptions(){
          //display the AlertController which shows the sort options
          let sortOptionsAlert: UIAlertController = UIAlertController(title: "Sort by", message: "Please select a sort option", preferredStyle: .actionSheet)
          let sortByDistanceAction = UIAlertAction(title: "Distance", style: .default) { _ in
              self.restaurantsViewModel.sortRestaurants(sortOptions: .Distance)}
          sortOptionsAlert.addAction(sortByDistanceAction)
          let sortByNameAction = UIAlertAction(title: "Name", style: .default){ _ in
              self.restaurantsViewModel.sortRestaurants(sortOptions: .Name)}
          sortOptionsAlert.addAction(sortByNameAction)
          let sortByRatingAction = UIAlertAction(title: "Rating", style: .default){ _ in
              self.restaurantsViewModel.sortRestaurants(sortOptions: .Rating)}
          sortOptionsAlert.addAction(sortByRatingAction)
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in}
          sortOptionsAlert.addAction(cancelAction)
          self.present(sortOptionsAlert, animated: true, completion: nil)
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
        if searchText.isEmpty {
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                   searchBar.resignFirstResponder()
               }
        }
        restaurantsViewModel.searchForRestaurant(restaurant: searchBar.text ?? "")
    }
    

    
}
