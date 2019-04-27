
import UIKit
import Utils

class PortfolioViewController: UICollectionViewController, StoryboardLoadable {

    var interactor: PortfolioInteracting?
    var router: PortfolioRouting?

    private let refreshControl = UIRefreshControl()
    private var imageUrls = [URL]()
}

// MARK: - Overrides
extension PortfolioViewController{
    
    override func viewDidLoad(){
        super.viewDidLoad()
        refreshControl.addTarget(self,
                                 action: #selector(didPullToRefresh),
                                 for: .valueChanged)
        refreshControl.tintColor = .white
        collectionView.refreshControl = refreshControl
        view.backgroundColor = .init(hex: "343537")
        interactor?.fetchArts()
    }
}

// MARK: - UICollectionViewDataSource
extension PortfolioViewController {
    override func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseId = PortfolioImageCell.reuseIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId,
                                                      for: indexPath)
        guard let imageViewCell = cell as? PortfolioImageCell else {
            return cell
        }
        guard imageUrls.indices.contains(indexPath.row) else {
            return imageViewCell
        }
        imageViewCell.setImageURL(imageUrls[safe: indexPath.row])
        return imageViewCell
    }
}

// MARK: - UICollectionViewDelegate
extension PortfolioViewController {
    override func collectionView(_ collectionView: UICollectionView,
                        didHighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.alpha = 0.5
    }

    override func collectionView(_ collectionView: UICollectionView,
                        didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.alpha = 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        interactor?.selectArt(atIndex: indexPath.row)
        router?.routeToListing()
    }
}

extension PortfolioViewController: PortfolioDisplaying {
    func displayIsLoading(_ isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            if isLoading {
                self?.refreshControl.beginRefreshingProgramatically()
            } else {
                self?.refreshControl.endRefreshing()
            }
        }
    }

    func displayImageUrls(_ urls: [URL]) {
        DispatchQueue.main.async { [weak self] in
            self?.imageUrls = urls
            self?.collectionView.reloadData()
        }
    }

    func displayErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            let alertViewController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertViewController.addAction(okAction)
            self.present(alertViewController, animated: true)
        }
    }
}

private extension PortfolioViewController {

    @objc func didPullToRefresh() {
        interactor?.fetchArts()
    }
}
