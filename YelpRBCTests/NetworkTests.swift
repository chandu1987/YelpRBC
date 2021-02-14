//
//  NetworkTests.swift
//  YelpRBCTests
//
//  Created by Chandra Sekhar Ravi on 14/02/21.
//

import XCTest
@testable import YelpRBC

class NetworkTests: XCTestCase {
    
    var networkManager: NetworkManager!
    let getRestaurantsUrl = URL(string: "https://api.yelp.com/v3/businesses/search?term=italian&latitude=43.668401&longitude=-79.371758&limit=10")!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolMock.self]
        let urlSession = URLSession.init(configuration: configuration)
        networkManager = NetworkManager(urlSession: urlSession)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkManager = nil

    }

    func testSuccessResponse() {
        
        //data
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "restaurants", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        
        //response
        let response = HTTPURLResponse(url: getRestaurantsUrl , statusCode: 200, httpVersion: nil, headerFields: nil)!
        URLProtocolMock.mockURLs = [getRestaurantsUrl: (nil, data, response)]
        
        let expectation = XCTestExpectation(description: "successCall")
    
        networkManager.call(for: GetRestaurantsEndpoint()) { (result) in
            switch result{
            case .success(let business):
                XCTAssertNotNil(business, "response returned nil")
                XCTAssertEqual(1, business.restaurants.count)
            case .failure(let error):
                print(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    
 
    
    
func testNetworkFailure_404Code() {

    //data
    let testBundle = Bundle(for: type(of: self))
    let path = testBundle.path(forResource: "restaurants", ofType: "json")
    let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)

    //response
    let response = HTTPURLResponse(url: getRestaurantsUrl , statusCode: 404, httpVersion: nil, headerFields: nil)!
    URLProtocolMock.mockURLs = [getRestaurantsUrl: (nil, data, response)]

        let expectation = XCTestExpectation(description: "failureCall")
    networkManager.call(for: GetRestaurantsEndpoint()) { (result) in
            switch result{
            case .success(_):
                XCTFail("Error from API")
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, "Network Error")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }




func testParseFailure_NoData() {
    //response
    let response = HTTPURLResponse(url: getRestaurantsUrl , statusCode: 200, httpVersion: nil, headerFields: nil)!
    URLProtocolMock.mockURLs = [getRestaurantsUrl: (nil, nil, response)]
        let expectation = XCTestExpectation(description: "failureCall")
    networkManager.call(for: GetRestaurantsEndpoint()) { (result) in
            switch result{
            case .success(_):
                XCTFail("Error from API")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }


}
