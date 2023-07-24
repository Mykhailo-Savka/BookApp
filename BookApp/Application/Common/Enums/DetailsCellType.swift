//
//  DetailsCellType.swift
//  BookApp
//
//  Created by Savka Mykhailo on 23.07.2023.
//

import Foundation

enum DetailsCellType {
    case informationCell(book: Book)
    case summaryCell(book: Book)
    case alsoLikeCell(books: [Book])
}
