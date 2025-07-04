//
//  DetailsPresenter.swift
//  IOSTask
//
//  Created by Nasser Lamei on 04/07/2025.
//

import Foundation
protocol DetailsView: AnyObject {
    func render<T>(state: Constants.ViewState<T>)
    func reloadTable()
    func showLoader()
    func hideLoader()
}
class DetailsPresenter {
    
    private let apiService: APIServiceProtocol
    weak var view: DetailsView?
    
    private(set) var posts: [PostModel] = []
    private(set) var paginatedPosts: [PostModel] = []
    private var postsPerPage = 10
    private var limit = 10
    
    init(apiService: APIServiceProtocol = APIService.shared, view: DetailsView) {
        self.apiService = apiService
        self.view = view
    }
    func fetchPosts() {
        view?.render(state: Constants.ViewState<[PostModel]>.loading)
        apiService.request(Constants.API.posts) { (result: Result<[PostModel], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self.view?.render(state: Constants.ViewState<[PostModel]>.success(posts))
                    self.posts = posts
                    self.limit = posts.count
                    for i in 0..<10 {
                        self.paginatedPosts.append(posts[i])
                    }
                    self.postsPerPage = 10
                    self.view?.render(state: .success(self.paginatedPosts))
                case .failure(let error):
                    self.view?.render(state: Constants.ViewState<[PostModel]>.error(error.localizedDescription))
                }
            }
        }
    }
    func loadMorePosts() {
        view?.showLoader()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            if self.postsPerPage >= self.limit {
                DispatchQueue.main.async {
                    self.view?.hideLoader()
                }
                return
            }
            
            if self.postsPerPage >= self.limit - 10 {
                for i in self.postsPerPage ..< self.limit {
                    self.paginatedPosts.append(self.posts[i])
                }
                self.postsPerPage += 10
            } else {
                for i in self.postsPerPage ..< self.postsPerPage + 10 {
                    self.paginatedPosts.append(self.posts[i])
                }
                self.postsPerPage += 10
            }
            
            DispatchQueue.main.async {
                self.view?.hideLoader()
                self.view?.reloadTable()
            }
        }
    }
    
    func numberOfPosts() -> Int {
        return paginatedPosts.count
    }
    
    func post(at index: Int) -> PostModel {
        return paginatedPosts[index]
    }
}
