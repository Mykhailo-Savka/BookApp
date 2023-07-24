//
//  CarouselBookCollectionViewCell.swift
//  BookApp
//
//  Created by Savka Mykhailo on 23.07.2023.
//

import UIKit
import Kingfisher

// MARK: - HourlyTableViewCell
final class CarouselBookCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var carouselBookImage: UIImageView!
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        carouselBookImage.image = nil
    }
    
    // MARK: - Public method
    func configure(with imageURL: String) {
        carouselBookImage.kf.setImage(with: URL(string: imageURL))
    }
}
