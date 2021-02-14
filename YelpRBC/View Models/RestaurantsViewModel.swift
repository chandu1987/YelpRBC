//
//  RestaurantsListViewModel.swift
//  YelpRBC
//
//  Created by Chandra Sekhar Ravi on 10/02/21.
//

import Foundation

enum Sorting {
    case Distance
    case Name
    case Rating
}

class RestaurantsViewModel:NSObject {
    //MARK : - Properties
    private var networkManager:NetworkManager!
    private var isSearching = false
    private var allRestaurants:[Restaurant]!
    private(set) var restaurants : [Restaurant]! {
        didSet{
            self.getrestaurantsDataClosure()
        }
    }
        
    var numberOfRestaurants :Int {
        guard self.restaurants != nil else{
            return 0
        }
        
        return self.restaurants.count
    }
    
    //Closures
    var getrestaurantsDataClosure : (() -> ()) = {}
    var getErrorUpdate : ((Error) -> Void)?

    override init() {
        super.init()
        //Network Manager
        self.networkManager = NetworkManager()
        getRestaurantsList()
    }
    
    //MARK: - Custom Functions
    //API Call
    func getRestaurantsList() {
        networkManager.call(for: GetRestaurantsEndpoint()) { (result) in
            switch(result){
            case .success(let business):
                self.allRestaurants = business.restaurants
                self.restaurants = self.allRestaurants
            case .failure(let error):
                self.getErrorUpdate?(error)
            }
        }
    }
    
    
    //get id for the restaurant to get the detail
    func getRestaurantId(_ index:Int) -> String {
        let restaurant = getRestaurantAtIndex(index)
        return restaurant.id
    }
    
    //get restaurant from an index in restaurants array
    func getRestaurantAtIndex(_ index : Int) -> Restaurant  {
        return restaurants[index]
    }
    
    //sort functionality
    func sortRestaurants(sortOptions:Sorting){
        switch sortOptions{
        case .Name:
            self.restaurants =  self.allRestaurants.sorted(by: {$0.name < $1.name})
        case .Distance:
            self.restaurants =  self.allRestaurants.sorted(by: {$0.distance ?? 0.0 < $1.distance ?? 0.0})
        case .Rating:
            self.restaurants =  self.allRestaurants.sorted(by: {$0.rating ?? 0.0 > $1.rating ?? 0.0})
        }
    }
    
    //search functionality
    func searchForRestaurant(restaurant:String){
        if restaurant.count > 0{
            isSearching = true
            let filteredResults = self.allRestaurants.filter{($0.name.range(of: restaurant, options: .caseInsensitive) != nil)}
            self.restaurants = filteredResults
        }else{
            isSearching = false
            self.restaurants = allRestaurants
        }
    }
    

}

