//
//  RestaurantDetail.swift
//  YelpRBC
//
//  Created by Chandra Sekhar Ravi on 10/02/21.
//

import Foundation


class RestaurantDetailViewModel:NSObject {
    //MARK : - Properties
    private var restaurantId:String!
    private var networkManager:NetworkManager!
    private(set) var restaurantDetail : Restaurant! {
        didSet{
            self.getrestaurantsDetailClosure()
        }
    }
    
    
    var title:String{
        return restaurantDetail.name
    }
    
    var isOpen:String{
        if restaurantDetail.isClosed == true{
            return "CLOSED"
        }else{
            return "OPEN"
        }
    }
    
    var cuisine:String?{
        if let category =  restaurantDetail.categories.first{
            return category.title.uppercased()
        }
        return nil
    }
    
    var imageUrl:URL{
        return URL(string: restaurantDetail.imageURL)!
    }
    
    var rating:String{
            if let rating = restaurantDetail.rating {
                
                let fullStars = Int(modf(rating).0)
                var starRating = ""
                for _ in 0..<fullStars{
                    starRating = starRating + Constants.StringConstants.kStar
                }
                
                let halfStars = modf(rating).1
                if halfStars + 0.5 == 1.0{
                    starRating = starRating + "1/2"
                }
                
                return starRating + "(\(restaurantDetail.reviewCount) reviews)"
            }
            return "No ratings yet"
    }
    
    var address:String{
            if let location = restaurantDetail.location{
                return (location.address1 ?? "") + " " + location.zipCode
            }
            return "No Address mentioned."
    }
    
    var phoneNumber:String{
        return restaurantDetail.displayPhone.count > 0 ? restaurantDetail.displayPhone : "No contact available"
    }
    
    //Closures
    var getrestaurantsDetailClosure : (() -> ()) = {}
    var getErrorUpdate : ((Error) -> Void)?
    
    //initialiser
    init(restaurantId:String){
        super.init()
        self.restaurantId = restaurantId
        self.networkManager = NetworkManager()
        self.getRestaurantDetail()
    }
    
    //MARK: - Custom Functions
    //API Call
    func getRestaurantDetail() {
        let endPoint = GetRestaurantDetailEndPoint(path: restaurantId)
        networkManager.call(for: endPoint) { (result) in
            switch(result){
            case .success(let restaurantDetail):
                self.restaurantDetail = restaurantDetail
            case .failure(let error):
                self.getErrorUpdate?(error)
            }
        }
    }
    

    func getPhotosCount() -> Int {
        guard restaurantDetail != nil else{
            return 0
        }
        
        if let photos = restaurantDetail.photos{
            return photos.count
        }
        return 0
    }
    
    func getPhotoUrl(_ index:Int) -> String {
        return restaurantDetail.photos![index]
    }
    
    
    
    
    
}
