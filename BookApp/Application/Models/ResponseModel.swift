//
//  ResponseModel.swift
//  BookApp
//
//  Created by Savka Mykhailo on 21.07.2023.
//

import Foundation

// MARK: - ResponseModel
struct ResponseModel: Codable {
    let books: [Book]
    let topBannerSlides: [TopBannerSlide]
    let youWillLikeSection: [Int]

    enum CodingKeys: String, CodingKey {
        case books
        case topBannerSlides = "top_banner_slides"
        case youWillLikeSection = "you_will_like_section"
    }
}
