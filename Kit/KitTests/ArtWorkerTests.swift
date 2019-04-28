
import XCTest
import TestTools
@testable import Kit

class ArtWorkerTests: XCTestCase {

    var sut: ArtWorkerDefault!

    var apiRequestFactorySpy: APIRequestFactorySpy!
    var networkRequestFactorySpy: NetworkRequestFactorySpy!
    var networkServiceSpy: NetworkServiceSpy!
    var artFactorySpy: ArtFactorySpy!

    var apiRequestMock: APIRequestMock!
    var networkRequestMock: NetworkRequestMock!
    var artMock: ArtMock!

    override func setUp() {
        super.setUp()

        apiRequestMock = .init()
        networkRequestMock = .init()
        artMock = .init()

        apiRequestFactorySpy = .init(createRequestResult: apiRequestMock)
        networkRequestFactorySpy = .init(networkRequestResult: .success(networkRequestMock))
        networkServiceSpy = .init(processRequestResult: .success(Seeds.data))
        artFactorySpy = .init(artsResult: .success([artMock]))
        sut = .init(apiRequestFactory: apiRequestFactorySpy,
                    networkRequestFactory: networkRequestFactorySpy,
                    networkService: networkServiceSpy,
                    artFactory: artFactorySpy)
    }
}

extension ArtWorkerTests {
    func test_fetchArt(){
        let exp = XCTestExpectation()
        sut.fetchArt { (result) in
            XCTAssertEqual([self.artMock], result.unwrap() as? [ArtMock])
            XCTAssertEqual([APIEndpoint.art], self.apiRequestFactorySpy.createRequestArgs)
            XCTAssertEqual([self.apiRequestMock], self.networkRequestFactorySpy.networkRequestArgs as? [APIRequestMock])
            XCTAssertEqual([self.networkRequestMock], self.networkServiceSpy.processRequestArgs as? [NetworkRequestMock])
            XCTAssertEqual([self.networkServiceSpy.processRequestResult.unwrap()], self.artFactorySpy.artsArgs)
            exp.fulfill()
        }
        wait(for: exp)
    }

    func test_fetchArt_networkRequestError(){
        let exp = XCTestExpectation()
        networkRequestFactorySpy.networkRequestResult = .failure(Seeds.error)
        sut.fetchArt { (result) in
            XCTAssertTrue(result.isFailure)
            exp.fulfill()
        }
        wait(for: exp)
    }

    func test_fetchArt_networkServiceError(){
        let exp = XCTestExpectation()
        networkServiceSpy.processRequestResult = .failure(Seeds.error)
        sut.fetchArt { (result) in
            XCTAssertTrue(result.isFailure)
            exp.fulfill()
        }
        wait(for: exp)
    }

    func test_fetchArt_artFactoryError(){
        let exp = XCTestExpectation()
        artFactorySpy.artsResult = .failure(Seeds.error)
        sut.fetchArt { (result) in
            XCTAssertTrue(result.isFailure)
            exp.fulfill()
        }
        wait(for: exp)
    }
}