//
//  BookCollectionViewCell.swift
//  BookApp
//
//  Created by Savka Mykhailo on 21.07.2023.
//

import UIKit
import Kingfisher

// MARK: - BookCollectionViewCell
final class BookCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var bookName: UILabel!
    @IBOutlet private weak var bookImage: UIImageView!
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bookName.text = nil
        bookImage.image = nil
    }

    // MARK: - Public method
    func configure(with name: String, bookImageURL: String, isAlsoLike: Bool) {
        bookName.text = name
        bookName.textColor = isAlsoLike ?
        Constants.Colors.likedBookTitleColor :
        Constants.Colors.bookTitleColor
        bookImage.kf.setImage(with: URL(string: bookImageURL))
    }
}
