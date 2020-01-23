//
//  TvShowsPresenter.swift
//  DistilledTV
//
//  Created by Barry on 20/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation
import UIKit

protocol PopularShowsPresenter {
    func loadData()
    func loadNextPage()
    func loadImage(for show: PopularShow) -> UIImage?
    func showActivity()
    func hideActivity()
    func sort(_ shows: [PopularShow]?) -> [PopularShow]?
}

class PopularShowsDefaultPresenter {
    
    var shows: [PopularShow]?
    weak var view: PopularShowsView?
    let interactor: PopularShowsInteractor
    let router: PopularShowsRouter
    var lastPage = 0
    var totalPages = Int.max

    init(view: PopularShowsView, interactor: PopularShowsInteractor, router: PopularShowsRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension PopularShowsDefaultPresenter: PopularShowsPresenter {
    func loadData() {
        lastPage = 0
        loadNextPage()
    }
    
    func loadImage(for show: PopularShow) -> UIImage? {
        if let poster = interactor.loadPoster(for: show, then: interactorHandler()) {
            return UIImage(data: poster.image)
        } else {
            return UIImage(named: "")
        }
    }
    
    func loadNextPage() {
        let nextPage = lastPage + 1
        guard nextPage < totalPages else { return }
        interactor.loadShows(page: nextPage, then: interactorHandler())
    }
    
    func sort(_ shows: [PopularShow]?) -> [PopularShow]? {
        guard let shows = shows else { return nil }
        return interactor.sort(shows: shows)
    }
    
    func showActivity() {
        router.showActivity()
    }
    
    func hideActivity() {
        router.hideActivity()
    }
}

extension PopularShowsDefaultPresenter {
    func interactorHandler() -> LoadPopularShowsHandler {
        return { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .successPopularShows(let popularShows):
                    strongSelf.handle(popularShows)
                case .successPoster(let poster):
                    strongSelf.handle(poster)
                case .failed(let error):
                    strongSelf.handle(error)
                case .startActivity:
                    strongSelf.showActivity()
                case .stopActivity:
                    strongSelf.hideActivity()
                }
            }
        }
    }
    
    func handle(_ newShows: PopularShows?) {
        guard let newShows = newShows else { return }
        
        lastPage = newShows.page
        totalPages = newShows.totalPages
        
        let current = shows ?? [PopularShow]()
        let next = newShows.results
        shows = current + next
        
        view?.display(shows)
    }
    
    func handle(_ poster: PopularShowPoster?) {
        guard let poster = poster else { return }
        if let image = UIImage(data: poster.image) {
            view?.display(image, for: poster.show)
        }
    }
    
    func handle(_ error: APIError) {
        switch error {
        case .apiError, .decodeError, .invalidEndpoint, .invalidResponse, .noData:
            view?.display("default_error_message".localized)
        }
    }
}
