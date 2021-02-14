//
//  URLProtocolMock.swift
//  YelpRBCTests
//
//  Created by Chandra Sekhar Ravi on 13/02/21.
//

import UIKit

class URLProtocolMock: URLProtocol {
    static var mockURLs = [URL?: (error: Error?, data: Data?, response: HTTPURLResponse?)]()

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let url = request.url {
            if let (error, data, response) = URLProtocolMock.mockURLs[url] {
                
                //  mock response
                if let responseStrong = response {
                    self.client?.urlProtocol(self, didReceive: responseStrong, cacheStoragePolicy: .notAllowed)
                }
                
                //  mocked data
                if let dataStrong = data {
                    self.client?.urlProtocol(self, didLoad: dataStrong)
                }
                
                //  mocked error
                if let errorStrong = error {
                    self.client?.urlProtocol(self, didFailWithError: errorStrong)
                }
            }
        }

        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
