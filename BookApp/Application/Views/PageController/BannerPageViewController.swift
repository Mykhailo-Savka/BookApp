//
//  BannerPageViewController.swift
//  BookApp
//
//  Created by Savka Mykhailo on 22.07.2023.
//

import UIKit

// MARK: - BannerPageViewController
final class BannerPageViewController: UIPageViewController {
    
    // MARK: - Private properties
    private var items: [String] = []
    private var controllersArray: [UIViewController] = []
    private var timer: Timer?
    private let scrollInterval: TimeInterval = 3
    
    // MARK: - Public properties
    var indexChanged: ((Int) -> Void)?
    var onBannerItem: ((Int) -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        startAutoScroll()
    }
    
    // MARK: - Private methods
    private func startAutoScroll() {
        timer = Timer.scheduledTimer(
            timeInterval: scrollInterval,
            target: self,
            selector: #selector(scrollToNextPage),
            userInfo: nil,
            repeats: true
        )
    }
    
    // MARK: - @objc private method
    @objc private func scrollToNextPage() {
        guard let currentViewController = viewControllers?.first,
              let nextViewController = dataSource?.pageViewController(
                self,
                viewControllerAfter: currentViewController
              ),
              let index = controllersArray.firstIndex(of: nextViewController) else { return }
        setViewControllers(
            [nextViewController],
            direction: .forward,
            animated: true,
            completion: nil
        )
        indexChanged?(index)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let tapPoint = gesture.location(in: view)
        if view.bounds.contains(tapPoint) {
            guard let vc = viewControllers?.first,
                  let index = controllersArray.firstIndex(of: vc) else { return }
            onBannerItem?(index)
        }
    }
    
    // MARK: - Public method
    func configure(with items: [String]) {
        self.items = items
        controllersArray = items.map({ BannerItemViewController(image: $0) })
        if let firstViewController = controllersArray.first {
            setViewControllers(
                [firstViewController],
                direction: .forward,
                animated: true,
                completion: nil
            )
        }
    }
}

// MARK: - UIPageViewControllerDataSource implementation
extension BannerPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = controllersArray.firstIndex(of: viewController) else { return nil}
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else { return controllersArray.last }
        guard controllersArray.count > previousIndex else { return nil }
        return controllersArray[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = controllersArray.firstIndex(of: viewController) else { return nil}
        let nextIndex = vcIndex + 1
        guard nextIndex < controllersArray.count else { return controllersArray.first }
        guard controllersArray.count > nextIndex else { return nil }
        return controllersArray[nextIndex]
    }
    
}

// MARK: - UIPageViewControllerDelegate implementation
extension BannerPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
              let vc = pageViewController.viewControllers?.first,
              let index = controllersArray.firstIndex(of: vc) else { return }
        indexChanged?(index)
    }
}
