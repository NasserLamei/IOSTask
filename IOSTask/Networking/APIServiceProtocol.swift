//
//  APIServiceProtocol.swift
//  IOSTask
//
//  Created by Nasser Lamei on 04/07/2025.
//

import Foundation
import Alamofire

protocol APIServiceProtocol {
    func request<T: Decodable>(_ url: String, completion: @escaping (Result<T, Error>) -> Void)
}

