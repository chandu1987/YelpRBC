//
//  GetRestaurantDetailEndPoint.swift
//  YelpRBC
//
//  Created by Chandra Sekhar Ravi on 10/02/21.
//

import Foundation


struct GetRestaurantDetailEndPoint: Endpoint {
    var path: String
    typealias DataType = Restaurant
    var queryItems: [URLQueryItem] = []
}
