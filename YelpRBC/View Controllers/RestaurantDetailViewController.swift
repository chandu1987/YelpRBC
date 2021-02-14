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
    @IBOutlet weak var statusButton:UIButton!
    @IBOutlet weak var cuisineButton:UIButton!
    @IBOutlet weak var subView:UIView!
    @IBOutlet weak var contentView:UIView!
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
        
        statusButton.layer.cornerRadius = 20.0
        cuisineButton.layer.cornerRadius = 20.0
    
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contentView.layer.cornerRadius = 10.0
        contentView.clipsToBounds = true
        
        subView.layer.masksToBounds = false
        subView.layer.shadowColor = UIColor.black.cgColor
        subView.layer.shadowOffset = .zero
        subView.layer.shadowOpacity = 1
        subView.layer.shadowRadius = 10
        let shadowPath = UIBezierPath(rect: subView.bounds)
        subView.layer.shadowPath = shadowPath.cgPath
     
        
        
       
    }
    
    
    func getRestaurantDetail(){
        self.restaurantDetailViewModel.getrestaurantsDetailClosure = {[weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }
    
    
    func updateUI(){
        restaurantImageView.loadImage(at: self.restaurantDetailViewModel.imageUrl)
        ratingLabel.text = "\u{2BEA}"
        restaurantNameLabel.text = self.restaurantDetailViewModel.title
        addressLabel.text = self.restaurantDetailViewModel.address
        phoneNumberLabel.text = self.restaurantDetailViewModel.phoneNumber
        statusButton.setTitle(self.restaurantDetailViewModel.isOpen, for: .normal)
        if let cuisine = self.restaurantDetailViewModel.cuisine{
            cuisineButton.setTitle(cuisine, for: .normal)
        }else{
            cuisineButton.isHidden = true
        }
        
        
        
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
