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
    func load()
    func paginate()
    func loadImage(for show: PopularShow) -> UIImage?
    func sort(_ shows: [PopularShow]?) -> [PopularShow]?
    func handle(_ newShows: PopularShows?)
    func handle(_ poster: PopularShowPoster?)
    func handle(_ error: Error)
}

final class PopularShowsDefaultPresenter {
    
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
    func load() {
        lastPage = 0
        paginate()
    }
    
    func loadImage(for show: PopularShow) -> UIImage? {
        if let poster = interactor.loadPoster(for: show, then: interactorHandler()) {
            return poster.image
        } else {
            return UIImage(named: "")
        }
    }
    
    func paginate() {
        router.showActivity()
        let nextPage = lastPage + 1
        guard nextPage < totalPages else { return }
        interactor.loadShows(page: nextPage, then: interactorHandler())
    }
    
    func sort(_ shows: [PopularShow]?) -> [PopularShow]? {
        guard let shows = shows else { return nil }
        return interactor.sort(shows: shows)
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
        router.hideActivity()
    }
    
    func handle(_ poster: PopularShowPoster?) {
        guard let poster = poster else { return }
        view?.display(poster.image, for: poster.show)
    }
    
    func handle(_ error: Error) {
        view?.display("")
    }
}
