//
//  PostModel.swift
//  IOSTask
//
//  Created by Nasser Lamei on 04/07/2025.
//

import Foundation

struct PostModel: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
