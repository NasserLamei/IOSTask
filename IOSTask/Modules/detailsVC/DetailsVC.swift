//
//  DetailsVC.swift
//  IOSTask
//
//  Created by Nasser Lamei on 04/07/2025.
//

import Foundation
import UIKit


class DetailsVC: UIViewController{
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var lblLocationName: UILabel!
    
    var location: LocationModel?
    private var presenter: DetailsPresenter!

     override func viewDidLoad() {
         super.viewDidLoad()
         presenter = DetailsPresenter(view: self)
         setUpUI()
         setUpTableView()
         presenter.fetchPosts()
     }
     private func setUpUI() {
         title = Constants.ViewTitles.details
         navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
         lblLocationName.text = "location name : \(location?.name ?? "N/A")"
     }

     private func setUpTableView() {
         tbView.rowHeight = UITableView.automaticDimension
         tbView.separatorStyle = .none
         tbView.showsVerticalScrollIndicator = false
         tbView.dataSource = self
         tbView.delegate = self
         tbView.register(UINib(nibName: Constants.CellIdentifiers.PostsCell, bundle: nil),
                         forCellReuseIdentifier: Constants.CellIdentifiers.PostsCell)
     }
}

extension DetailsVC: DetailsView {
    func render<T>(state: Constants.ViewState<T>) {
        switch state {
        case .loading:
            showHUD(progressLabel: Constants.AlertTitles.pleaseWait)

        case .success(_):
            dismissHUD(isAnimated: true)
            tbView.reloadData()

        case .error(let message):
            showHUD(progressLabel: message)
        }
    }

    func reloadTable() {
        tbView.reloadData()
    }
    func showLoader() {
        showHUD(progressLabel: Constants.AlertTitles.pleaseWait)
    }

    func hideLoader() {
        dismissHUD(isAnimated: true)
    }
}
//MARK: - UITableViewDelegate, UITableViewDataSource
extension DetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfPosts()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.PostsCell, for: indexPath) as! PostsCell
        cell.configureCell(data: presenter.post(at: indexPath.row))
        return cell
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.tbView {
            if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
                presenter.loadMorePosts()
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
}
