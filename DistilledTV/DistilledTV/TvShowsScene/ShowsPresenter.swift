//
//  TvShowsPresenter.swift
//  DistilledTV
//
//  Created by Barry on 20/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation

protocol ShowsPresenter {
    func loadData()
}

class ShowsDefaultPresenter: ShowsPresenter {
    
    private weak var view: ShowsListView?
    private let interactor: ShowsInteractor = ShowsDefaultInteractor()
    
    init(view: ShowsListView) {
        self.view = view
    }
    
    func loadData() {
        interactor.loadShows(page: 1, then: interactorHandler())
    }
    
    func loadNextPage() {
        
    }
}

extension ShowsDefaultPresenter {
    
    func interactorHandler() -> LoadShowsHandler {
        return { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .successPopularShows(let shows):
                    strongSelf.handle(shows)
                case .failed(let error):
                    strongSelf.handle(error)
                }
            }
        }
    }
    
    func handle(_ shows: [Show]) {
        print(shows)
        view?.display(shows)
    }
    
    func handle(_ error: Error) {
        print(error)
    }
    
}
