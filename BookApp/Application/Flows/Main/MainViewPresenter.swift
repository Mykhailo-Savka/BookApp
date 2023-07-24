//
//  MainViewPresenter.swift
//  BookApp
//
//  Created by Savka Mykhailo on 21.07.2023.
//

import Foundation
import FirebaseRemoteConfig

// MARK: - MainViewPresenterProtocol
protocol MainViewPresenterProtocol: AnyObject {
    var alsoLikeBooks: [Book] { get }
    var topBannerSlides: [TopBannerSlide] { get }
    var bookListDictionary: [String : [Book]] { get }
    var bookListSortedKeys: [String] { get }
    
    func viewLoaded()
    func bannerItemTapped(with index: Int)
    func bookCellTapped(with book: Book)
}

// MARK: - MainViewPresenter
final class MainViewPresenter {
    
    // MARK: - Private properties
    private (set) var topBannerSlides: [TopBannerSlide] = []
    private (set) var bookListDictionary: [String : [Book]] = [:]
    private (set) var bookListSortedKeys: [String] = []
    private (set) var alsoLikeBooks: [Book] = []
    private var books: [Book] = []
    
    // MARK: - Public properties
    weak var view: MainViewControllerProtocol?
    
    // MARK: - Lifecycle
    init(view: MainViewControllerProtocol) {
        self.view = view
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
            
            let jsonString = remoteConfig.configValue(forKey: "json_data").stringValue
            if let jsonData = jsonString?.data(using: .utf8) {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    if let jsonDict = jsonObject as? [String: Any] {
                        let json = try JSONSerialization.data(withJSONObject: jsonDict)
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(ResponseModel.self, from: json)
                        self.books = model.books
                        self.alsoLikeBooks = self.getAlsoLikeBooks(
                            from: model.youWillLikeSection,
                            books: model.books
                        )
                        self.topBannerSlides = model.topBannerSlides
                        self.bookListDictionary = self.setupBookListDictionary(from: model.books)
                        self.bookListSortedKeys = self.sortDictionaryKeys(
                            from: self.bookListDictionary.keys.map({ $0 })
                        )
                        self.view?.reloadData()
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func setupBookListDictionary(from books: [Book]) -> [String : [Book]] {
        var booksDictionary: [String: [Book]] = [:]
        books.forEach { book in
            let key = book.genre
            if var bookByGenre = booksDictionary[key] {
                bookByGenre.append(book)
                booksDictionary[key] = bookByGenre
            } else {
                booksDictionary[key] = [book]
            }
        }
        
        return booksDictionary
    }
    
    private func sortDictionaryKeys(from keys: [String]) -> [String] {
        let sortedKeys = keys.sorted()
        return sortedKeys
    }
    
    private func getAlsoLikeBooks(from bookIDs: [Int], books: [Book]) -> [Book] {
        var bookList: [Book] = []
        books.forEach { book in
            bookIDs.forEach { id in
                if book.id == id {
                    bookList.append(book)
                }
            }
        }
        return bookList
    }
}

// MARK: - MainViewPresenterProtocol implementation
extension MainViewPresenter: MainViewPresenterProtocol {
    func viewLoaded() {
        view?.setupUI()
    }
    
    func bannerItemTapped(with index: Int) {
        let bookID = topBannerSlides[index].bookID
        guard let book = books.first(where: { $0.id == bookID }) else { return }
        view?.pushDetailsScreen(with: book)
    }
    
    func bookCellTapped(with book: Book) {
        view?.pushDetailsScreen(with: book)
    }
}
