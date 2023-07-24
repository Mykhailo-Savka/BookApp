//
//  MainViewController.swift
//  BookApp
//
//  Created by Savka Mykhailo on 21.07.2023.
//

import UIKit

// MARK: - MainViewControllerProtocol
protocol MainViewControllerProtocol: AnyObject {
    func setupUI()
    func reloadData()
    func pushDetailsScreen(with book: Book)
}

// MARK: - MainViewController
final class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Public properties
    var presenter: MainViewPresenterProtocol!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private methods
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
                return self.createBannerSection()
            } else {
                return self.createHorizontalSection()
            }
        }
        
        return layout
    }
    
    private func createHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constants.Common.bookCellWidth),
            heightDimension: .absolute(Constants.Common.bookCellHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.Common.inset,
            leading: Constants.Common.inset,
            bottom: Constants.Common.inset,
            trailing: Constants.Common.inset
        )
        section.interGroupSpacing = Constants.Common.groupSpacing
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(Constants.MainScreen.headerHeight)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(UIScreen.main.bounds.width - 32),
            heightDimension: .absolute(Constants.MainScreen.bannerHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.Common.inset,
            leading: Constants.Common.inset,
            bottom: Constants.Common.inset,
            trailing: Constants.Common.inset
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(Constants.MainScreen.headerHeight)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}

// MARK: - MainViewControllerProtocol implementation
extension MainViewController: MainViewControllerProtocol {
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "HeaderView"
        )
        collectionView.collectionViewLayout = createCompositionalLayout()
        collectionView.registerCell(BannerCollectionViewCell.self)
        collectionView.registerCell(BookCollectionViewCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func pushDetailsScreen(with book: Book) {
        let detailViewController = DetailsViewController(
            nibName: "DetailsViewController",
            bundle: nil
        )
        let presenter = DetailsViewPresenter(
            view: detailViewController,
            alsoLikeBooks: presenter.alsoLikeBooks,
            selectedBook: book
        )
        detailViewController.presenter = presenter
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource implementation
extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.bookListSortedKeys.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            let key = presenter.bookListSortedKeys[section - 1]
            return presenter.bookListDictionary[key]?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueCell(BannerCollectionViewCell.self, indexPath: indexPath)
            let items = presenter.topBannerSlides.map({ $0.cover })
            cell.configure(with: items.count)
            cell.childViewController?.removeFromParent()
            let childVC = BannerPageViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal
            )
            childVC.configure(with: items)
            cell.childViewController = childVC
            childVC.indexChanged = { index in
                cell.change(index: index)
            }
            childVC.onBannerItem = { [weak self] index in
                self?.presenter.bannerItemTapped(with: index)
            }
            if let view = childVC.view {
                cell.set(view: view)
                addChild(childVC)
                childVC.didMove(toParent: self)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueCell(BookCollectionViewCell.self, indexPath: indexPath)
            let key = presenter.bookListSortedKeys[indexPath.section - 1]
            let book = presenter.bookListDictionary[key]?[indexPath.row]
            cell.configure(
                with: book?.name ?? "",
                bookImageURL: book?.coverURL ?? "",
                isAlsoLike: false
            )
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "HeaderView",
                for: indexPath
              ) as? HeaderView else {
            return UICollectionReusableView()
        }
        if indexPath.section == 0 {
            headerView.configure(
                with: Constants.MainScreen.libraryTitle,
                titleColor: Constants.Colors.libraryTitleColor ?? .white
            )
        } else {
            headerView.configure(
                with: presenter.bookListSortedKeys[indexPath.section - 1],
                titleColor: UIColor.white
            )
        }
        return headerView
    }
}

// MARK: - UICollectionViewDelegate implementation
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView && indexPath.section != 0 {
            let key = presenter.bookListSortedKeys[indexPath.section - 1]
            guard let book = presenter.bookListDictionary[key]?[indexPath.row] else { return }
            presenter.bookCellTapped(with: book)
        }
    }
}
