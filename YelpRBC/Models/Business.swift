//
//  Business.swift
//  YelpRBC
//
//  Created by Chandra Sekhar Ravi on 10/02/21.
//

import Foundation

// MARK: - Restaurant
struct Business: Codable {
    let restaurants: [Restaurant]
    let total: Int
    let region: Region
    
    enum CodingKeys: String, CodingKey {
        case restaurants = "businesses"
        case total
        case region
    }
    
}

// MARK: - Business
struct Restaurant: Codable {
    let id, alias, name: String
    let imageURL: String
    let isClosed: Bool
    let isClaimed:Bool?
    let url: String
    let reviewCount: Int
    let categories: [Category]
    let rating: Float?
    let coordinates: Center
    let photos: [String]?
    let price: String
    let location: Location?
    let phone, displayPhone: String
    let distance: Double?

    enum CodingKeys: String, CodingKey {
        case id, alias, name
        case imageURL = "image_url"
        case isClosed = "is_closed"
        case isClaimed = "is_claimed"
        case url
        case reviewCount = "review_count"
        case categories, rating, coordinates, photos, price, location, phone
        case displayPhone = "display_phone"
        case distance
    }
}

// MARK: - Category
struct Category: Codable {
    let alias, title: String
}

// MARK: - Center
struct Center: Codable {
    let latitude, longitude: Double
}

// MARK: - Location
struct Location: Codable {
    let address1, address2, address3, city: String?
    let zipCode, country, state: String
    let displayAddress: [String]

    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city
        case zipCode = "zip_code"
        case country, state
        case displayAddress = "display_address"
    }
}

// MARK: - Region
struct Region: Codable {
    let center: Center
}

