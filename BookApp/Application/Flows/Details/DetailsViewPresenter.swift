//
//  DetailsViewPresenter.swift
//  BookApp
//
//  Created by Savka Mykhailo on 22.07.2023.
//

import Foundation
import FirebaseRemoteConfig

// MARK: - DetailsViewPresenterProtocol
protocol DetailsViewPresenterProtocol: AnyObject {
    var detailsCellTypes: [DetailsCellType] { get }
    var books: [Book] { get }
    
    func viewLoaded()
    func itemChanged(for index: Int)
}

// MARK: - DetailsViewPresenter
final class DetailsViewPresenter {
    
    // MARK: - Private properties
    private (set) var detailsCellTypes: [DetailsCellType] = []
    private (set) var books: [Book] = []
    private let alsoLikeBooks: [Book]
    private let selectedBook: Book
    
    // MARK: - Public properties
    weak var view: DetailsViewControllerProtocol?
    
    // MARK: - Lifecycle
    init(view: DetailsViewControllerProtocol, alsoLikeBooks: [Book], selectedBook: Book) {
        self.view = view
        self.alsoLikeBooks = alsoLikeBooks
        self.selectedBook = selectedBook
        setupViewData(book: selectedBook, alsoLikeBooks: alsoLikeBooks)
        fetchRemoteConfigData()
    }
    
    // MARK: - Private methods
    private func fetchRemoteConfigData() {
        let remoteConfig = RemoteConfig.remoteConfig()
        
        remoteConfig.fetchAndActivate { (status, error) in
            if let error = error {
                print("Error fetching remote config: \(error.localizedDescription)")
                return
            }
            
            let jsonString = remoteConfig.configValue(forKey: "details_carousel").stringValue
            if let jsonData = jsonString?.data(using: .utf8) {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    if let jsonDict = jsonObject as? [String: Any] {
                        let json = try JSONSerialization.data(withJSONObject: jsonDict["books"] as Any)
                        let decoder = JSONDecoder()
                        let model = try decoder.decode([Book].self, from: json)
                        self.books = model
                        let index = self.books.firstIndex(where: { $0.id == self.selectedBook.id })
                        self.view?.updateData(with: self.selectedBook, index: index ?? 0)
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func setupViewData(book: Book, alsoLikeBooks: [Book]) {
        detailsCellTypes.removeAll()
        detailsCellTypes.append(.informationCell(book: book))
        detailsCellTypes.append(.summaryCell(book: book))
        detailsCellTypes.append(.alsoLikeCell(books: alsoLikeBooks))
    }
}

// MARK: - DetailsViewPresenterProtocol implementation
extension DetailsViewPresenter: DetailsViewPresenterProtocol {
    func viewLoaded() {
        view?.setupUI()
    }
    
    func itemChanged(for index: Int) {
        let book = books[index]
        setupViewData(book: book, alsoLikeBooks: alsoLikeBooks)
        view?.tableViewReloadData(with: book)
    }
}
