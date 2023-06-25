//
//  ViewController.swift
//  moviedb
//
//  Created by Rashed Sahajee on 24/06/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - View Property
    @IBOutlet weak var collectionView: UICollectionView!
    private let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    //MARK: - ViewModel
    private let homeViewModel: HomeViewModelProtocol = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        self.setupCollectionView()
        self.bindViewModel()
        Task {
            await homeViewModel.fetchPhotosList()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.bounds = view.bounds
        activityIndicatorView.backgroundColor = .white.withAlphaComponent(0.5)
    }
    
    private func bindViewModel() {
        homeViewModel.photosList.bind { [weak self] _ in
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.delegate = self
                self?.collectionView.dataSource = self
                self?.collectionView.reloadData()
            }
        }
        homeViewModel.allItemsLoaded.bind { [weak self] _ in
            //MARK: - Adding some delay in order to show loader, and confirming pagination completed
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
                self?.activityIndicatorView.stopAnimating()
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func setupCollectionView() {
        let layout = createCollectionViewLayout()
        collectionView.collectionViewLayout = layout
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        // Create item size
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(250))
        
        // Create item
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Set up item insets
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        // Create group size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(250))
        
        // Create group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Create section
        let section = NSCollectionLayoutSection(group: group)
        
        // Set interitem spacing
        section.interGroupSpacing = 8
        
        // Create layout
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
        
    }
}

extension HomeViewController : UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.bounds.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        
        // Check if we've reached the bottom of the content and there are more items to load
        if !(homeViewModel.currentPage == 3) {
            if offsetY > contentHeight - visibleHeight && !homeViewModel.isLoading && !homeViewModel.allItemsLoaded.value {
                homeViewModel.currentPage += 1
                activityIndicatorView.startAnimating()
                Task {
                    await homeViewModel.fetchPhotosList()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = homeViewModel.photosList.value?[indexPath.item] else {return}
        let detailsViewModel = DetailsViewModel(selectedItem: selectedItem)
        let detailVC = DetailsViewController.configure(viewModel: detailsViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.photosList.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let photo = homeViewModel.photosList.value?[indexPath.item] else {return UICollectionViewCell()}
        cell.configure(with: photo)
        return cell
    }
}
