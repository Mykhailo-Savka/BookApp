//
//  TopBannerSlide.swift
//  BookApp
//
//  Created by Savka Mykhailo on 21.07.2023.
//

import Foundation

// MARK: - TopBannerSlide
struct TopBannerSlide: Codable {
    let id, bookID: Int
    let cover: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case bookID = "book_id"
        case cover
    }
}
