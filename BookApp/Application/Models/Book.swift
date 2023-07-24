//
//  Book.swift
//  BookApp
//
//  Created by Savka Mykhailo on 21.07.2023.
//

import Foundation

// MARK: - Book
struct Book: Codable {
    let id: Int
    let name, author, summary, genre: String
    let coverURL: String
    let views, likes, quotes: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, author, summary, genre
        case coverURL = "cover_url"
        case views, likes, quotes
    }
}
