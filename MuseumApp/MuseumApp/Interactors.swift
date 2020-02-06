import MuseumKit

public struct ViewModels {

    public let artCollectionViewModel: ArtCollectionViewModel
    public let artDetailsInteractor: ArtDetailsViewModel

    public init(appState: AppState,
                interactors: Interactors) {
        self.artCollectionViewModel = .init(appState: appState, artInteractor: interactors.artInteractor)
        self.artDetailsInteractor = .init(appState: appState)
    }
}

public struct Interactors {
    public let systemInteractor: SystemInteractor
    public let artInteractor: ArtInteractor

    public init(appState: AppState,
                services: Services) {
        self.systemInteractor = SystemInteractorDefault(appState: appState)
        self.artInteractor = ArtInteractorDefault(appState: appState, museumWebService: services.museumWebService)
    }
}
