//
//  DetailsViewController.swift
//  BookApp
//
//  Created by Savka Mykhailo on 22.07.2023.
//

import UIKit

// MARK: - DetailsViewControllerProtocol
protocol DetailsViewControllerProtocol: AnyObject {
    func setupUI()
    func updateData(with book: Book, index: Int)
    func tableViewReloadData(with book: Book)
}

// MARK: - DetailsViewController
final class DetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var bookNameLabel: UILabel!
    @IBOutlet private weak var bookAuthorLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Public properties
    var presenter: DetailsViewPresenterProtocol!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupNavigationBar()
    }
    
    // MARK: - Private methods
    private func setupTableView() {
        tableView.dataSource = self
        tableView.registerCell(InformationTableViewCell.self)
        tableView.registerCell(SummaryTableViewCell.self)
        tableView.registerCell(AlsoLikeTableViewCell.self)
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(CarouselBookCollectionViewCell.self)
        collectionView.decelerationRate = .fast
        collectionView.collectionViewLayout = CarouselFlowLayout()
    }
    
    private func itemChanged() {
        let collectionViewCenter = CGPoint(
            x: collectionView.bounds.midX,
            y: collectionView.bounds.midY
        )
        guard let indexPathForCenterCell = collectionView.indexPathForItem(at: collectionViewCenter) else { return }
        let currentVisibleIndex = indexPathForCenterCell.item
        presenter.itemChanged(for: currentVisibleIndex)
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Constants.Colors.detailsBackgroundColor
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupBackButton() {
        navigationItem.setHidesBackButton(true, animated: true)
        let backButton = UIButton(type: .custom)
        backButton.setImage(Constants.Icons.backButtonIcon, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    // MARK: - @objc private method
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - DetailsViewControllerProtocol implementation
extension DetailsViewController: DetailsViewControllerProtocol {
    func setupUI() {
        setupTableView()
        setupCollectionView()
        bookNameLabel.isHidden = true
        bookAuthorLabel.isHidden = true
        setupBackButton()
    }
    
    func updateData(with book: Book, index: Int) {
        tableView.reloadData()
        collectionView.reloadData()
        bookNameLabel.isHidden = false
        bookAuthorLabel.isHidden = false
        bookNameLabel.text = book.name
        bookAuthorLabel.text = book.author
        collectionView.scrollToItem(
            at: IndexPath(item: index, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
    }
    
    func tableViewReloadData(with book: Book) {
        tableView.reloadData()
        bookNameLabel.text = book.name
        bookAuthorLabel.text = book.author
        view.setNeedsLayout()
    }
}

// MARK: - UICollectionViewDelegate implementation
extension DetailsViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        itemChanged()
    }
}

// MARK: - UICollectionViewDataSource implementation
extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(CarouselBookCollectionViewCell.self, indexPath: indexPath)
        cell.configure(with: presenter.books[indexPath.row].coverURL)
        return cell
    }
}

// MARK: - UITableViewDataSource implementation
extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.detailsCellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch presenter.detailsCellTypes[indexPath.row] {
        case .informationCell(let book):
            let informationCell = tableView.dequeueCell(InformationTableViewCell.self, indexPath: indexPath)
            informationCell.configure(
                readers: book.views,
                likes: book.likes,
                quotes: book.quotes,
                genre: book.genre
            )
            return informationCell
        case .summaryCell(let book):
            let summaryCell = tableView.dequeueCell(SummaryTableViewCell.self, indexPath: indexPath)
            summaryCell.configure(summary: book.summary)
            return summaryCell
        case .alsoLikeCell(let books):
            let alsoLikeCell = tableView.dequeueCell(AlsoLikeTableViewCell.self, indexPath: indexPath)
            alsoLikeCell.configure(with: books)
            return alsoLikeCell
        }
    }
}
