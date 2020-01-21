//
//  TvShowsPresenter.swift
//  DistilledTV
//
//  Created by Barry on 20/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation
import UIKit

protocol ShowsPresenter {
    func loadData()
    func loadNextPage()
    func loadImage(for show: Show) -> UIImage?
}

class ShowsDefaultPresenter: ShowsPresenter {
    
    private var shows: [Show]?
    private weak var view: ShowsListView?
    private let interactor: ShowsInteractor = ShowsDefaultInteractor()
    private var lastPage = 0
    private var totalPages = Int.max

    init(view: ShowsListView) {
        self.view = view
    }
    
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
}

extension ShowsDefaultPresenter {
    
    private func interactorHandler() -> LoadShowsHandler {
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
                    strongSelf.startActivity()
                case .stopActivity:
                    strongSelf.stopActivity()
                }
            }
        }
    }
    
    private func startActivity() {
        view?.startLoading()
    }
    
    private func stopActivity() {
        view?.startLoading()
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
    
    private func handle(_ error: Error) {
        print(error)
    }
}
