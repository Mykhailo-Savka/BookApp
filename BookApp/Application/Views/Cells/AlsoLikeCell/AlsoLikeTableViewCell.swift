//
//  AlsoLikeTableViewCell.swift
//  BookApp
//
//  Created by Savka Mykhailo on 22.07.2023.
//

import UIKit

// MARK: - AlsoLikeTableViewCell
final class AlsoLikeTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Private properties
    private var books: [Book] = []
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.registerCell(BookCollectionViewCell.self)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    // MARK: - Private methods
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            return self.createHorizontalSection()
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
            top: 0,
            leading: Constants.Common.inset,
            bottom: 0,
            trailing: Constants.Common.inset
        )
        section.interGroupSpacing = Constants.Common.groupSpacing
        
        return section
    }
    
    // MARK: - Public methods
    func configure(with books: [Book]) {
        self.books = books
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource implementation
extension AlsoLikeTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(BookCollectionViewCell.self, indexPath: indexPath)
        cell.configure(
            with: books[indexPath.row].name,
            bookImageURL: books[indexPath.row].coverURL,
            isAlsoLike: true
        )
        return cell
    }
}
