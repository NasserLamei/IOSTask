//
//  AddLocationPresenter.swift
//  IOSTask
//
//  Created by Nasser Lamei on 03/07/2025.
//

import Foundation


protocol AddLocationViewProtocol: AnyObject {
    func showLocations(_ locations: [LocationModel])
    func showValidationErrors(name: String?, latitude: String?, longitude: String?)
    func clearForm()
    func hideForm()
    func showForm()
    func toggleShowMapButton(enabled: Bool)
}

class AddLocationPresenter {
    private weak var view: AddLocationViewProtocol?
    private(set) var locations: [LocationModel] = []

    init(view: AddLocationViewProtocol) {
        self.view = view
    }

    func addLocation(name: String?, latitude: String?, longitude: String?) {
        let latText = latitude?.englishDigits.trimmingCharacters(in: .whitespaces) ?? ""
        let lngText = longitude?.englishDigits.trimmingCharacters(in: .whitespaces) ?? ""

        var nameError: String?
        var latError: String?
        var lngError: String?

        if name?.isEmpty ?? true {
            nameError = Constants.Validation.validName
        }
        let latValue = Double(latText)
        if latText.isEmpty {
            latError = Constants.Validation.validEmptyLatitude
        } else if latValue == nil || !(latValue! >= -90 && latValue! <= 90) {
            latError = Constants.Validation.validLatitude
        }
        
        let lngValue = Double(lngText)
        if lngText.isEmpty {
            lngError = Constants.Validation.validEmptyLongitude
        } else if lngValue == nil || !(lngValue! >= -180 && lngValue! <= 180) {
            lngError = Constants.Validation.validLongitude
        }

        if nameError != nil || latError != nil || lngError != nil {
            view?.showValidationErrors(name: nameError, latitude: latError, longitude: lngError)
            return
        }
        let newLocation = LocationModel(name: name!, latitude: latValue!, longitude: lngValue!)
        locations.append(newLocation)
        view?.clearForm()
        view?.hideForm()
        view?.toggleShowMapButton(enabled: locations.count > 1)
        view?.showLocations(locations)
    }

    func removeLocation(at index: Int) {
        locations.remove(at: index)
        view?.toggleShowMapButton(enabled: locations.count > 1)
        view?.showLocations(locations)
    }

    func openForm() {
        view?.showForm()
    }

    func closeForm() {
        view?.hideForm()
        view?.clearForm()
    }
}
