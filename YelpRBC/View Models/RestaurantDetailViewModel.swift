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
    
    private(set) var isLoading : Bool? {
        didSet{
            self.getLoadingStatus?(isLoading ?? false)
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
                return "\(rating)" +  "*"
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
        return restaurantDetail.displayPhone
    }
    
    //Closures
    var getrestaurantsDetailClosure : (() -> ()) = {}
    var getErrorUpdate : ((Error) -> Void)?
    var getLoadingStatus :((Bool) -> Void)?
    
    
    
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
        isLoading = true
        let endPoint = GetRestaurantDetailEndPoint(path: restaurantId)
        networkManager.call(for: endPoint) { (result) in
            self.isLoading = false
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
