//
//  SplashViewController.swift
//  BookApp
//
//  Created by Savka Mykhailo on 19.07.2023.
//

import UIKit

// MARK: - SplashViewController
final class SplashViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var progressView: UIProgressView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        startProgress()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private methods
    private func startProgress() {
        progressView.progress = 0.0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.progressView.progress += 0.1
            if self.progressView.progress >= 1.0 {
                timer.invalidate()
            }
        }
        
        RunLoop.current.add(timer, forMode: .common)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
            timer.invalidate()
            pushMainViewController()
        }
    }
    
    private func pushMainViewController() {
        let mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        let presenter = MainViewPresenter(view: mainViewController)
        mainViewController.presenter = presenter
        let navVC = UINavigationController(rootViewController: mainViewController)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
}
