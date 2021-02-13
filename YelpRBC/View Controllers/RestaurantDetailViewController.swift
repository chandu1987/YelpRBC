//
//  RestaurantDetailViewController.swift
//  YelpRBC
//
//  Created by Chandra Sekhar Ravi on 11/02/21.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    
    //MARK: - Properties    
    private var restaurantId :String!
    private var restaurantDetailViewModel:RestaurantDetailViewModel!

        
    //MARK: - IBOutlets
    @IBOutlet weak var restaurantImageView:UIImageView!
    @IBOutlet weak var restaurantNameLabel:UILabel!
    @IBOutlet weak var ratingLabel:UILabel!
    @IBOutlet weak var addressLabel:UILabel!
    @IBOutlet weak var phoneNumberLabel:UILabel!
    @IBOutlet weak var subView:UIView!
    @IBOutlet weak var photosCollectionView:UICollectionView!

    
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //The received data gets initialized below
      init?(coder: NSCoder, restaurantId:String) {
        self.restaurantId = restaurantId
        super.init(coder: coder)
      }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.restaurantDetailViewModel = RestaurantDetailViewModel(restaurantId:self.restaurantId)
        getRestaurantDetail()
        setupUI()
    }
    
    func setupUI(){
        subView.layer.cornerRadius = 10.0
        subView.clipsToBounds = true
    }
    
    
    func getRestaurantDetail(){
        self.restaurantDetailViewModel.getrestaurantsDetailClosure = {[weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }
    
    
    func updateUI(){
        restaurantImageView.load(url: self.restaurantDetailViewModel.getRestaurantImage())
        restaurantNameLabel.text = self.restaurantDetailViewModel.getRestaurantName()
        ratingLabel.text = self.restaurantDetailViewModel.getRestaurantRating()
        addressLabel.text = self.restaurantDetailViewModel.getRestaurantAddress()
        phoneNumberLabel.text = self.restaurantDetailViewModel.getPhoneNumber()
        photosCollectionView.reloadData()
    }


}


extension RestaurantDetailViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return restaurantDetailViewModel.getPhotosCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.kFoodImageCell, for: indexPath) as! DishCell
        cell.dishImageUrl = restaurantDetailViewModel.getPhotoUrl(indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: Constants.Segues.kShowRestaurantDetailSegue, sender: indexPath.item)
    }
}


extension RestaurantDetailViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: 128)
    }
    
}
