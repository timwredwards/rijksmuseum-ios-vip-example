import Foundation
import TimKit

internal protocol NetworkRequestFactory {
    func networkRequest(fromAPIRequest apiRequest: APIRequest) -> Result<NetworkRequest, Error>
}

internal class NetworkRequestFactoryDefault {
    let baseAPIConfig: APIBaseConfig
    init(baseAPIConfig: APIBaseConfig) {
        self.baseAPIConfig = baseAPIConfig
    }
}

extension NetworkRequestFactoryDefault: NetworkRequestFactory {
    func networkRequest(fromAPIRequest apiRequest: APIRequest) -> Result<NetworkRequest, Error> {
        return networkRequestResultFromAPIRequest(apiRequest)
    }
}

private extension NetworkRequestFactoryDefault {
    enum LocalError: String, LocalizedError {
        case unableToConstructURL
        case invalidScheme
        case invalidHost
        case invalidPath
    }

    struct NetworkRequestForAPI: NetworkRequest {
        var url: URL
        var method: NetworkMethod
    }
}

private extension NetworkRequestFactoryDefault {

    func networkRequestResultFromAPIRequest(_ apiRequest: APIRequest) -> Result<NetworkRequest, Error> {
        return Result {
            try validateAPIBaseConfig(baseAPIConfig)

            try validateAPIRequest(apiRequest)

            let networkRequestURL = try urlFromAPIBaseConfig(baseAPIConfig, apiRequest: apiRequest)

            return networkRequestFromURL(networkRequestURL, networkMethod: .GET)
        }
    }

    func validateAPIBaseConfig(_ config: APIBaseConfig) throws {
        try validateURLScheme(baseAPIConfig.scheme)
        try validateURLHost(baseAPIConfig.host)
    }

    func validateAPIRequest(_ apiRequest: APIRequest) throws {
        try validateURLPath(apiRequest.path)
    }

    func urlFromAPIBaseConfig(_ config: APIBaseConfig, apiRequest: APIRequest) throws -> URL {

        let urlComponents = urlComponentsFromAPIBaseConfig(baseAPIConfig)

        let urlComponentsExtended = extendURLComponents(urlComponents, usingAPIRequest: apiRequest)

        let finalURL = try urlFromURLComponents(urlComponentsExtended)

        return finalURL
    }

    func networkRequestFromURL(_ url: URL, networkMethod: NetworkMethod) -> NetworkRequest {
        return NetworkRequestForAPI(url: url, method: networkMethod)
    }
}

// MARK: - Validation
private extension NetworkRequestFactoryDefault {
    func validateURLScheme(_ scheme: String) throws {
        if scheme != "http" && scheme != "https" {
            throw LocalError.invalidScheme
        }
    }

    func validateURLHost(_ host: String) throws {
        if baseAPIConfig.host.isEmpty {
            throw LocalError.invalidHost
        }
    }

    func validateURLPath(_ path: String) throws {
        if path.isEmpty {
            throw LocalError.invalidPath
        }
    }
}

// MARK: - Creation
private extension NetworkRequestFactoryDefault {

    func urlComponentsFromAPIBaseConfig(_ apiBaseConfig: APIBaseConfig) -> URLComponents {
        var newURLComponents = URLComponents()
        newURLComponents.scheme = apiBaseConfig.scheme
        newURLComponents.host = apiBaseConfig.host
        newURLComponents.path = apiBaseConfig.path

        newURLComponents.queryItems = apiBaseConfig.queryItems.map({
            return URLQueryItem(name: $0.key, value: $0.value)
        })

        return newURLComponents
    }

    func extendURLComponents(_ urlComponents: URLComponents, usingAPIRequest apiRequest: APIRequest) -> URLComponents {
        var newURLComponents = urlComponents
        newURLComponents.path.append(apiRequest.path)

        let newQueryItems = apiRequest.queryItems.map({
            return URLQueryItem(name: $0.key, value: $0.value)
        })

        newURLComponents.queryItems?.append(contentsOf: newQueryItems)
        return newURLComponents
    }

    func urlFromURLComponents(_ urlComponents: URLComponents) throws -> URL {
        guard let url = urlComponents.url else {
            throw LocalError.unableToConstructURL
        }
        return url
    }
}
