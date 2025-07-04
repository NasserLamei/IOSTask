//
//  Constants.swift
//  IOSTask
//
//  Created by Nasser Lamei on 02/07/2025.
//

import Foundation

import Foundation

enum Constants {
    
    enum API {
        static let baseURL = "https://jsonplaceholder.typicode.com"
        static let posts = "\(baseURL)/posts"
    }

    enum Map {
        static let openStreetMapURL = URL(string: "https://basemaps.arcgis.com/arcgis/rest/services/OpenStreetMap_v2/VectorTileServer")!
    }

    enum CellIdentifiers {
        static let locationCell = "LocationTableViewCell"
        static let PostsCell = "PostsCell"
        
    }

    enum AlertTitles {
        static let noInternet = "No internet connection"
        static let error = "Error!"
        static let networkError = "Network error"
        static let pleaseWait = ""
        static let LocationInfo = "Location Info"
        static let noLocation = "No Locations"
        
    }
    enum ViewTitles {
        static let mapTitle = "Locations Map"
        static let addLocation = "Add Location"
        static let details = "Details"
        
        
    }
    
    enum ViewState<T> {
        case loading
        case success(T)
        case error(String)
    }
    
    enum Validation {
        static let validName = "Please enter a name."
        static let validEmptyLatitude = "Latitude is required."
        static let validLatitude = "Latitude must be a number between -90 and 90."
        static let validEmptyLongitude = "Longitude is required."
        static let validLongitude = "Longitude must be a number between -180 and 180."
       
        
    }
}

