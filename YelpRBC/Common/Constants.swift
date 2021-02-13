//
//  Constants.swift
//  YelpRBC
//
//  Created by Chandra Sekhar Ravi on 10/02/21.
//

import Foundation

struct Constants{
    
    //Urls
    struct Urls {
        static let kBaseUrl = "https://api.yelp.com/v3/businesses/"
        static let kGetRestaurantsUrl = "search"
    }
    
    //Segues
    struct Segues{
        static let kShowRestaurantDetailSegue = "ShowRestaurantDetailSegue"
    }
    
    //Cell identifiers
    struct CellIdentifiers {
        static let kRestaurantCellId = "RestaurantCell"
        static let kFoodImageCell = "FoodimageCell"
    }
    
    //API Keys
    struct APIKeys{
        static let kYelpAPIKey = "Bearer tfNnH1xnlzeAXrAdssQ8eEb3jxnlQpgaXuUfLlGc08VEAiLSnuOhprUHJ0ewtRfZVTf47VZJAj9oR2ZfsZqBCf4f07DslExZPnGtDIISXp4JeD8bb9kaze0aACQjYHYx"
    }

    
    
}
