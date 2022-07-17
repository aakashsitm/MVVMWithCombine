//
//  HttpUtility.swift
//  EliStore
//
//  Created by Akash Verma on 15/07/22.
//

import Foundation

struct HttpUtility
{
    static func getApiData<T:Decodable>(requestUrl: URL, resultType: T.Type, completion:@escaping(_ result: Result<T?, APIError>)-> Void)
    {        
        URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
            guard error == nil else  {
                completion(.failure(.serverError(message: error?.localizedDescription ?? "Request failed with Server error")))
                return
            }
            guard let data = data else {
                completion(.failure(.serverError(message: "Response Data is empty")))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.serverError(message: "Http response is empty")))
                return
            }
            if httpResponse.statusCode == 200 {
                do {
                    let topModel = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(topModel))
                } catch let exeception {
                    print(exeception)
                    completion(.failure(.decodingFailure(message: exeception.localizedDescription)))
                }
            } else {
                completion(.failure(.badResponse(statusCode: httpResponse.statusCode)))
            }
        }.resume()
    }

    static func postApiData<T:Decodable>(requestUrl: URL, requestBody: Data, resultType: T.Type, completion:@escaping(_ result: Result<Bool, APIError>)-> Void)
    {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "post"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else  {
                completion(.failure(.serverError(message: error?.localizedDescription ?? "Request failed with Server error")))
                return
            }
            guard data != nil else {
                completion(.failure(.serverError(message: "Response Data is empty")))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.serverError(message: "Http response is empty")))
                return
            }
            if httpResponse.statusCode == 200 {
                completion(.success(true))
            } else {
                completion(.success(false))
            }
        }.resume()
    }
}

enum APIError: Error {
    case badResponse(statusCode: Int)
    case serverError(message: String)
    case decodingFailure(message: String)
    
    var description: String {
        switch self {
        case .badResponse(let statusCode):
            return "The call failed with HTTP response code \(statusCode)."
        case .serverError(let message):
            return "The server responded with message \"\(message)\"."
        case .decodingFailure(let message):
            return "Decoding failed with message \"\(message)\"."
        }
    }
}
