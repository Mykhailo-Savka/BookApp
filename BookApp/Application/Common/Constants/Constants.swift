//
//  Constants.swift
//  BookApp
//
//  Created by Savka Mykhailo on 23.07.2023.
//

import UIKit

// MARK: - Constants
struct Constants {
    
    // MARK: - Constants
    struct Common {
        static let groupSpacing: CGFloat = 8
        static let inset: CGFloat = 16
        static let bookCellWidth: CGFloat = 120
        static let bookCellHeight: CGFloat = 190
        static let cornerRadius: CGFloat = 16
    }
    
    // MARK: - Colors
    struct Colors {
        static let likedBookTitleColor = UIColor(named: "liked_book_title_color")
        static let bookTitleColor = UIColor(named: "book_title_color")
        static let libraryTitleColor = UIColor(named: "library_title_color")
        static let detailsBackgroundColor = UIColor(named: "details_background_color")
    }
    
    // MARK: - Icons
    struct Icons {
        static let backButtonIcon = UIImage(named: "backButtonIcon")
    }
    
    // MARK: - MainScreen
    struct MainScreen {
        static let headerHeight: CGFloat = 44
        static let bannerHeight: CGFloat = 160
        static let libraryTitle = "Library"
    }
    
    // MARK: - InformationCell
    struct InformationCell {
        static let radius: CGFloat = 20
    }
    
    // MARK: - Fonts
    struct Fonts {
        static func semiBold(size: CGFloat = 20) -> UIFont {
            UIFont(name: "NunitoSans_7pt-SemiBold", size: size) ?? .systemFont(ofSize: 20)
        }
    }
}
