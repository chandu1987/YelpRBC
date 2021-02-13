//
//  GetRestaurantsEndPoint.swift
//  YelpRBC
//
//  Created by Chandra Sekhar Ravi on 10/02/21.
//

import Foundation

struct GetRestaurantsEndpoint: Endpoint {
    typealias DataType = Business
    var path: String = Constants.Urls.kGetRestaurantsUrl
    var queryItems: [URLQueryItem] = [
        //default search item
        URLQueryItem(name: "term", value: "italian"),
        //toronto Lat and longitudes
        URLQueryItem(name: "latitude", value: "43.668401"),
        URLQueryItem(name: "longitude", value: "-79.371758"),
        //only 10 restaurants to be shown
        URLQueryItem(name: "limit", value: "10")
    ]
}
