//
//  MockURLProtocol.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 14/6/25.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    static var stubResponseData: Data?
    static var stubStatusCode: Int = 200
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
 
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
