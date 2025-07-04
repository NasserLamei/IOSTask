//
//  ViewController.swift
//  testMap
//
//  Created by Nasser Lamei on 03/07/2025.
//
import UIKit
import ArcGIS

class AddLocationVC: UIViewController {
    //MARK: Outlets .
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var showMapBtn: UIButton!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var viewForm: UIView!
    @IBOutlet weak var tbView: UITableView!
    //name
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblNameValid: UILabel!
    //Latitude
    @IBOutlet weak var txtLatitude: UITextField!
    @IBOutlet weak var lblLatitudeValid: UILabel!
    //Longitude
    @IBOutlet weak var txtLongitude: UITextField!
    @IBOutlet weak var lblLongitudeValid: UILabel!
    
    private var presenter: AddLocationPresenter!
    
    //MARK: lifeCycle .
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        hideKeyboardWhenTappedAround()
        enableKeyboardAvoidance()
        setUpTableView()
        presenter = AddLocationPresenter(view: self)
    }
    //MARK: actions .
        @IBAction func showMapBtnTapped(_ sender: UIButton) {
            let mapVC = MapViewController()
            mapVC.locations = presenter.locations
            navigationController?.pushViewController(mapVC, animated: true)
        }
    
    @IBAction func plusBtnTapped(_ sender: UIButton) {
        presenter.openForm()
    }

    @IBAction func closeBtnTapped(_ sender: UIButton) {
        presenter.closeForm()
        plusBtn.isEnabled = true
        view.endEditing(true)
    }

    @IBAction func addLocationBtnTapped(_ sender: UIButton) {
        presenter.addLocation(name: txtName.text, latitude: txtLatitude.text, longitude: txtLongitude.text)
        view.endEditing(true)
    }
    private func setUpTableView(){
        tbView.delegate = self
        tbView.dataSource = self
        tbView.register(UINib(nibName: Constants.CellIdentifiers.locationCell, bundle: nil), forCellReuseIdentifier:  Constants.CellIdentifiers.locationCell)
    }
    private func setUpUI(){
        self.title = Constants.ViewTitles.addLocation
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationItem.backBarButtonItem = backBarButton
        txtName.delegate = self
        txtLatitude.delegate = self
        txtLongitude.delegate = self
    }
}

// MARK: - AddLocationView
extension AddLocationVC: AddLocationViewProtocol {
    func showLocations(_ locations: [LocationModel]) {
        viewEmpty.isHidden = !locations.isEmpty
        tbView.isHidden = locations.isEmpty
        tbView.reloadData()
    }

    func showValidationErrors(name: String?, latitude: String?, longitude: String?) {
        lblNameValid.text = name
        lblLatitudeValid.text = latitude
        lblLongitudeValid.text = longitude
        lblNameValid.isHidden = name == nil
        lblLatitudeValid.isHidden = latitude == nil
        lblLongitudeValid.isHidden = longitude == nil
    }

    func clearForm() {
        txtName.text = ""
        txtLatitude.text = ""
        txtLongitude.text = ""
    }
    
    func clearValidations(){
        lblNameValid.isHidden = true
        lblLatitudeValid.isHidden = true
        lblLongitudeValid.isHidden = true
    }

    func hideForm() {
        viewForm.isHidden = true
        plusBtn.isEnabled = true
        clearForm()
        clearValidations()
        view.endEditing(true)
    }
    func showForm() {
        viewForm.isHidden = false
        plusBtn.isEnabled = false
    }

    func toggleShowMapButton(enabled: Bool) {
        showMapBtn.isHidden = false
        showMapBtn.isEnabled = enabled
    }
}

// MARK: - TableView
extension AddLocationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  Constants.CellIdentifiers.locationCell, for: indexPath) as! LocationTableViewCell
        cell.configureCell(data: presenter.locations[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.removeLocation(at: indexPath.row)
        }
    }
}

// MARK: - TextField
extension AddLocationVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtName {
            txtLatitude.becomeFirstResponder()
        } else if textField == txtLatitude {
            txtLongitude.becomeFirstResponder()
        } else if textField == txtLongitude {
            textField.resignFirstResponder()
        }
        return true
    }
}
