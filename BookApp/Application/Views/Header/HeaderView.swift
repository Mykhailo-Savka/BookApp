//
//  HeaderView.swift
//  BookApp
//
//  Created by Savka Mykhailo on 24.07.2023.
//

import UIKit

// MARK: - HeaderView
final class HeaderView: UICollectionReusableView {
    
    // MARK: - Public properties
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.semiBold()
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // MARK: - Private method
    private func setupViews() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Public method
    func configure(with title: String, titleColor: UIColor) {
        titleLabel.text = title
        titleLabel.textColor = titleColor
    }
}
