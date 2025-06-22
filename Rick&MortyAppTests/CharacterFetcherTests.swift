//
//  CharacterFetcherTests.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 14/6/25.
//

import XCTest
@testable import Rick_MortyApp

final class CharacterFetcherTests: XCTestCase {

    var session: URLSession!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
    }

    override func tearDown() {
        session = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }

    func testFetchCharactersSuccess() async throws {
       
        let mockJSON = """
        {
          "info": {
            "count": 1,
            "pages": 1,
            "next": null,
            "prev": null
          },
          "results": [
            {
              "id": 1,
              "name": "Rick Sanchez",
              "status": "Alive",
              "species": "Human",
              "type": "",
              "gender": "Male",
              "origin": { "name": "Earth", "url": "" },
              "location": { "name": "Earth", "url": "" },
              "image": "https://rick.png",
              "episode": ["https://example.com/episode/1"],
              "url": "https://rickandmortyapi.com/api/character/1",
              "created": "2017-11-04T18:48:46.250Z"
            }
          ]
        }
        """.data(using: .utf8)!

        let episodeJSON = """
        {
          "id": 1,
          "name": "Pilot",
          "air_date": "December 2, 2013",
          "episode": "S01E01",
          "characters": [],
          "url": "",
          "created": ""
        }
        """.data(using: .utf8)!

        var callCount = 0

        MockURLProtocol.requestHandler = { (request: URLRequest) throws -> (HTTPURLResponse, Data) in
            callCount += 1
            let data = callCount == 1 ? mockJSON : episodeJSON
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }

        let fetcher = CharacterFetcher(session: session)
        let response = try await fetcher.fetchCharacters(page: 1)

        XCTAssertEqual(response.results?.count, 1)
        XCTAssertEqual(response.results?.first?.name, "Rick Sanchez")
        XCTAssertEqual(response.results?.first?.firstEpisodeName, "Pilot")
    }
    
    func testFetchCharactersFailure() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }

        let fetcher = CharacterFetcher(session: session)
        do {
            _ = try await fetcher.fetchCharacters(page: 1)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
}
