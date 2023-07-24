//
//  InformationTableViewCell.swift
//  BookApp
//
//  Created by Savka Mykhailo on 22.07.2023.
//

import UIKit

// MARK: - InformationTableViewCell
final class InformationTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var readersLabel: UILabel!
    @IBOutlet private weak var likesLabel: UILabel!
    @IBOutlet private weak var quotesLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        containerView.roundTopCorners(with: Constants.InformationCell.radius)
        readersLabel.text = nil
        likesLabel.text = nil
        quotesLabel.text = nil
        genreLabel.text = nil
    }
    
    // MARK: - Public method
    func configure(readers: String, likes: String, quotes: String, genre: String) {
        readersLabel.text = readers
        likesLabel.text = likes
        quotesLabel.text = quotes
        genreLabel.text = genre
    }
}
