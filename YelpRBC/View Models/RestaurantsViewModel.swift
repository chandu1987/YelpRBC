//
//  RestaurantsListViewModel.swift
//  YelpRBC
//
//  Created by Chandra Sekhar Ravi on 10/02/21.
//

import Foundation

class RestaurantsViewModel:NSObject {
    //MARK : - Properties
    private var networkManager:NetworkManager!
    private var isSearching = false
    private var filteredRestaurants:[Restaurant]!
    private var allRestaurants:[Restaurant]!
    private(set) var restaurants : [Restaurant]! {
        didSet{
            self.getrestaurantsDataClosure()
        }
    }
    
    private(set) var isLoading : Bool? {
        didSet{
            self.getLoadingStatus?(isLoading ?? false)
        }
    }
    
    var numberOfRestaurants :Int {
        guard self.restaurants != nil else{
            return 0
        }
        
        if isSearching{
            return filteredRestaurants.count
        }
        
        return self.restaurants.count
    }
    
    //Closures
    var getrestaurantsDataClosure : (() -> ()) = {}
    var getErrorUpdate : ((Error) -> Void)?
    var getLoadingStatus :((Bool) -> Void)?

    override init() {
        super.init()
        //Network Manager
        self.networkManager = NetworkManager()
        getRestaurantsList()
    }
    
    //MARK: - Custom Functions
    //API Call
    func getRestaurantsList() {
        isLoading = true
        networkManager.call(for: GetRestaurantsEndpoint()) { (result) in
            self.isLoading = false
            switch(result){
            case .success(let business):
                self.restaurants = business.restaurants
            case .failure(let error):
                self.getErrorUpdate?(error)
            }
        }
    }
    
    func getRestaurantId(_ index:Int) -> String {
        let restaurant = getRestaurantAtIndex(index)
        return restaurant.id
    }
    
    //get restaurant from an index in restaurants array
    func getRestaurantAtIndex(_ index : Int) -> Restaurant  {
        return restaurants[index]
    }
    
    //search functionality
    func searchForRestaurant(restaurant:String){
        let filteredResults = self.restaurants.filter{($0.name.range(of: restaurant, options: .caseInsensitive) != nil)}
        self.restaurants = filteredResults
    }
    

}

