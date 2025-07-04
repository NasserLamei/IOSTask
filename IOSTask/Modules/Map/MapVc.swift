//
//  MapVc.swift
//  IOSTask
//
//  Created by Nasser Lamei on 03/07/2025.
//

import UIKit
import ArcGIS
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {

    var locations: [LocationModel] = []

    private var mapView: AGSMapView!
    private var presenter: MapPresenter!
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        configureMapLocation()
    }
  private func setUpUI() {
    title = Constants.ViewTitles.mapTitle
    view.backgroundColor = .white
    let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem = backBarButton
    }
    private func configureMapLocation(){
        guard !locations.isEmpty else {
            showAlert(title: Constants.AlertTitles.noLocation, message: "There are no locations to display.", location: nil)
            navigationController?.popViewController(animated: true)
            return
        }
        // Location setup
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // MapView setup
        mapView = AGSMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        mapView.touchDelegate = self

        // Presenter
        presenter = MapPresenter(locations: locations, delegate: self)
        mapView.graphicsOverlays.add(presenter.overlay)
        presenter.populateGraphics()
    }
    func showAlert(title: String, message: String, location: LocationModel?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .cancel))

        if let location = location {
            alert.addAction(UIAlertAction(title: "Show Details", style: .default) { [weak self] _ in
                let story = UIStoryboard(name: "DetailsView", bundle: nil)
                let detailsVC = story.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
                detailsVC.location = location
                self?.navigationController?.pushViewController(detailsVC, animated: true)
            })
        }

        present(alert, animated: true)
    }

    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            let point = AGSPoint(x: loc.coordinate.longitude, y: loc.coordinate.latitude, spatialReference: .wgs84())
            mapView.setViewpoint(AGSViewpoint(center: point, scale: 100_000), completion: nil)
            locationManager.stopUpdatingLocation()

            mapView.locationDisplay.autoPanMode = .recenter
            mapView.locationDisplay.start(completion: nil)
        }
    }
}

extension MapViewController: MapPresenterDelegate {
    func configureMap(_ map: AGSMap) {
        mapView.map = map
        if let first = locations.first {
            let point = AGSPoint(x: first.longitude, y: first.latitude, spatialReference: .wgs84())
            mapView.setViewpoint(AGSViewpoint(center: point, scale: 100_000), completion: nil)
        }
    }

    func highlightGraphic(_ graphic: AGSGraphic) {
        graphic.symbol = AGSSimpleMarkerSymbol(style: .circle, color: .blue, size: 14)
    }

    func resetPreviouslySelectedGraphic(_ graphic: AGSGraphic) {
        graphic.symbol = AGSSimpleMarkerSymbol(style: .circle, color: .red, size: 10)
    }
}

extension MapViewController: AGSGeoViewTouchDelegate {
    func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        guard let overlay = presenter.overlay as? AGSGraphicsOverlay else { return }
        mapView.identify(overlay, screenPoint: screenPoint, tolerance: 12, returnPopupsOnly: false, maximumResults: 1) { result in
            self.presenter.handleTap(on: result.graphics.first)
        }
    }
}
