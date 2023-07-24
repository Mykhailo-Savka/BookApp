//
//  SummaryTableViewCell.swift
//  BookApp
//
//  Created by Savka Mykhailo on 22.07.2023.
//

import UIKit

// MARK: - SummaryTableViewCell
final class SummaryTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var summaryLabel: UILabel!
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        summaryLabel.text = nil
    }
    
    // MARK: - Public method
    func configure(summary: String) {
        summaryLabel.text = summary
    }
}
