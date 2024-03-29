//
//  HTTPClient.swift
//  ArabamCom
//
//  Created by Muhammet  on 16.04.2023.
//

import Foundation
protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}
extension HTTPClient {
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path

        guard var url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        if let params = endpoint.params{
            url = url.appendingQueryParameters(params)
        }
        
        var request = URLRequest(url: url)
            request.httpMethod = endpoint.method.rawValue
             request.allHTTPHeaderFields = endpoint.header
        
     
        if let body = endpoint.body {
                request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            }
    
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
//        NetworkLog.log(request: request)
                return .failure(.noResponse)
            }
//        NetworkLog.log(data: data, response: response, error: RequestError.decode)
          
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary: URLQueryParameterStringConvertible {
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let encodedKey = String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let encodedValue = String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let part = "\(encodedKey)=\(encodedValue)"
            parts.append(part)
        }
        return parts.joined(separator: "&")
    }
}

extension URL {
    func appendingQueryParameters(_ parametersDictionary: [String: Any]) -> URL {
        let URLString: String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}
