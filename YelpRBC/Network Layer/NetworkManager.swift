//
//  NetworkManager.swift
//  YelpRBC
//
//  Created by Chandra Sekhar Ravi on 10/02/21.
//

import UIKit

enum NetworkError : Error {
    case networkError
    case parsingError
}

//Add custom descriptions to errors
extension NetworkError : LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network Error"
        case .parsingError:
            return "Parsing Error"
        }
    }
}


class NetworkManager  {
    
    private let urlSession: URLSession
    
    //Dependency injection incase we want to mock test the network layer.takes the default url session if nothing is passed.
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    
    
   @discardableResult func call<EndpointType>(for endpoint: EndpointType, completion: @escaping (Result<EndpointType.DataType, Error>) -> Void) -> URLSessionDataTask? where EndpointType : Endpoint {
        var request = endpoint.makeRequest(baseURL: URL(string: Constants.Urls.kBaseUrl)!)
        request.setValue(Constants.APIKeys.kYelpAPIKey, forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { data, urlResponse, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if urlResponse == nil{
                fatalError()
            }
            
            // Check response code.
            guard let httpResponse = urlResponse as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(Result.failure(NetworkError.networkError))
                return
            }
            
            
            guard let data = data else {
                completion(.failure(NetworkError.parsingError))
                return
            }
            
            let result = Result {
                try endpoint.decoder.decode(EndpointType.DataType.self, from: data)
            }
            print(result)
            completion(result)
        }
        task.resume()
        return task
    }

    
    
    //Get Restaurants list
//    func getRestaurantsList(completion : @escaping (_ result: Result<[Restaurant], Error>) -> Void){
//        
//        let restaurantsListUrl = URL(string: Constants.Urls.kBaseUrl + Constants.Urls.kGetRestaurantsUrl)!
//        
//        urlSession.dataTask(with: restaurantsListUrl) { (data, urlResponse, error) in
//            do{
//                //check for error
//                if let error = error {
//                    throw error
//                }
//                
//                // Check response code.
//                guard let httpResponse = urlResponse as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
//                    completion(Result.failure(NetworkError.networkError))
//                    return
//                }
//     
//                //parse it and return
//                if let responseData = data, let business = try? JSONDecoder().decode(Business.self, from: responseData) {
//                    completion(Result.success(business.restaurants))
//                } else {
//                    completion(Result.failure(NetworkError.parsingError))
//                }
//                
//            }catch{
//                completion(Result.failure(error))
//            }
//            
//        }.resume()
//    }
//    
    
}

