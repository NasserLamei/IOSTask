//
//  LocationModel.swift
//  IOSTask
//
//  Created by Nasser Lamei on 03/07/2025.
//

import Foundation

struct LocationModel:Identifiable {
    let name: String
    let latitude: Double
    let longitude: Double
    let id = UUID()
}


extension LocationModel: Equatable {
    static func == (lhs: LocationModel, rhs: LocationModel) -> Bool {
        return lhs.name == rhs.name &&
               lhs.latitude == rhs.latitude &&
               lhs.longitude == rhs.longitude
    }
}
