//
//  BannerCollectionViewCell.swift
//  BookApp
//
//  Created by Savka Mykhailo on 21.07.2023.
//

import UIKit

// MARK: - BannerCollectionViewCell
final class BannerCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    // MARK: - Public properties
    var childViewController: BannerPageViewController?
    
    // MARK: - Public methods
    func configure(with numberOfPages: Int) {
        pageControl.currentPage = 0
        pageControl.numberOfPages = numberOfPages
    }
    
    func change(index: Int) {
        pageControl.currentPage = index
    }
    
    func set(view: UIView) {
        containerView.addSubview(view)
        view.frame = containerView.bounds
        view.layer.cornerRadius = Constants.Common.cornerRadius
    }
}
