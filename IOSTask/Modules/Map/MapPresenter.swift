//
//  MapPresenter.swift
//  IOSTask
//
//  Created by Nasser Lamei on 04/07/2025.
//

import Foundation

import ArcGIS

protocol MapPresenterDelegate: AnyObject {
    func configureMap(_ map: AGSMap)
    func showAlert(title: String, message: String,location:LocationModel?)
    func highlightGraphic(_ graphic: AGSGraphic)
    func resetPreviouslySelectedGraphic(_ graphic: AGSGraphic)
}

class MapPresenter {
    private(set) var locations: [LocationModel]
    private weak var delegate: MapPresenterDelegate?
    private(set) var overlay = AGSGraphicsOverlay()
    private var selectedGraphic: AGSGraphic?

    init(locations: [LocationModel], delegate: MapPresenterDelegate) {
        self.locations = locations
        self.delegate = delegate
        setupMap()
    }

    private func setupMap() {
        let osmLayer = AGSArcGISVectorTiledLayer(url: Constants.Map.openStreetMapURL)
        let basemap = AGSBasemap(baseLayer: osmLayer)
        let map = AGSMap(basemap: basemap)
        delegate?.configureMap(map)
    }

    func populateGraphics() {
        for location in locations {
            let point = AGSPoint(x: location.longitude, y: location.latitude, spatialReference: .wgs84())
            let symbol = AGSSimpleMarkerSymbol(style: .circle, color: .red, size: 10)
            let attributes: [String: Any] = [
                "name": location.name,
                "latitude": location.latitude,
                "longitude": location.longitude
            ]
            let graphic = AGSGraphic(geometry: point, symbol: symbol, attributes: attributes)
            overlay.graphics.add(graphic)
        }
    }

    func handleTap(on graphic: AGSGraphic?) {
        guard let graphic = graphic else { return }

        if let selected = selectedGraphic {
            delegate?.resetPreviouslySelectedGraphic(selected)
        }

        delegate?.highlightGraphic(graphic)
        selectedGraphic = graphic

        if let name = graphic.attributes["name"] as? String,
           let lat = graphic.attributes["latitude"] as? Double,
           let lon = graphic.attributes["longitude"] as? Double {
            let message = """
            Name: \(name)
            Latitude: \(lat)
            Longitude: \(lon)
            """
            
            let location = locations.first(where: {
                $0.name == name &&
                $0.latitude == lat &&
                $0.longitude == lon
            })

            delegate?.showAlert(title: Constants.AlertTitles.LocationInfo, message: message, location: location)
            
        }
    }
}
