//
//  PortfolioInteractor.swift
//  Rijksmuseum
//
//  Created by Tim Edwards on 29/07/2018.
//  Copyright (c) 2018 Tim Edwards. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class PortfolioInteractor: PortfolioDataStore{
    let presenter: PortfolioPresentationLogic
    var selectedPrimitive: ArtPrimitive?
    init(presenter:PortfolioPresentationLogic) {
        self.presenter = presenter
    }
}

extension PortfolioInteractor: PortfolioBusinessLogic {
    func fetchArt(request: Portfolio.FetchArt.Request) {
        let artPrimitiveSource = ArtPrimitiveAPI()
        let worker = ArtPrimitivesWorker(artPrimitiveSource: artPrimitiveSource)
        worker.fetchPrimitives {[weak self] (result) in
            guard let sSelf = self else {return}
            switch result {
            case .success(let artPrimitives):
                sSelf.presenter.didFetchArt(response: Portfolio.FetchArt.Response(artPrimitives: artPrimitives))
            case .failure(_):
                fatalError()
            }
        }
    }
}
