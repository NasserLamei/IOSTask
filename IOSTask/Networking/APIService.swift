//
//  APIService.swift
//  IOSTask
//
//  Created by Nasser Lamei on 04/07/2025.
//
import Foundation
import Alamofire

class APIService: APIServiceProtocol {
    static let shared = APIService()
    private init() {}
    func request<T: Decodable>(_ url: String, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let decoded):
                completion(.success(decoded))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

