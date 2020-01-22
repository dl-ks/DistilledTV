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
    func loadImage(for show: Show) -> UIImage?
    func showActivity()
    func hideActivity()
}

class PopularShowsDefaultPresenter {
    
    private var shows: [Show]?
    private weak var view: PopularShowsView?
    private let interactor: PopularShowsInteractor
    private let router: PopularShowsRouter
    private var lastPage = 0
    private var totalPages = Int.max

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
    
    func loadImage(for show: Show) -> UIImage? {
        if let poster = interactor.loadPoster(for: show, then: interactorHandler()) {
            return UIImage(data: poster.image)
        }
        else {
            return UIImage(named: "")
        }
    }
    
    func loadNextPage() {
        let nextPage = lastPage + 1
        guard nextPage < totalPages else {
            return
        }
        interactor.loadShows(page: nextPage, then: interactorHandler())
    }
    
    func showActivity() {
        router.showActivity()
    }
    
    func hideActivity() {
        router.hideActivity()
    }
}

extension PopularShowsDefaultPresenter {
    
    private func interactorHandler() -> LoadPopularShowsHandler {
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
    
    private func handle(_ newShows: PopularShows?) {
        guard let newShows = newShows else { return }
        
        lastPage = newShows.page
        totalPages = newShows.totalPages
        
        let current = shows ?? [Show]()
        let next = newShows.results
        shows = current + next
        
        view?.display(shows)
    }
    
    private func handle(_ poster: ShowPoster?) {
        guard let poster = poster else { return }
        if let image = UIImage(data: poster.image) {
            view?.display(image, for: poster.show)
        }
    }
    
    private func handle(_ error: APIError) {
        switch error {
        case .apiError, .decodeError, .invalidEndpoint, .invalidResponse, .noData:
            view?.display("default_error_message".localized)
        }
    }
}
