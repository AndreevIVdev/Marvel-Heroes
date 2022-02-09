//
//  FullScreenAvatarViewController.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 11.01.2022.
//


import UIKit

protocol FullScreenAvatarViewable: AnyObject {
    func set(withModel model: FullScreenAvatarViewModel)
    func showAllert(title: String?, message: String?, buttonTitle: String?)
}

class FullScreenAvatarViewController: MHDataLoadingViewController {
    
    var presenter: FullScreenAvatarPresentable!
    private var avatarImageView: UIImageView = .init(image: Images.placeholder)
    private let scrollView: UIScrollView = .init()
    
    weak var imageViewBottomConstraint: NSLayoutConstraint!
    weak var imageViewLeadingConstraint: NSLayoutConstraint!
    weak var imageViewTopConstraint: NSLayoutConstraint!
    weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        configureImageView()
        presenter.getModel()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
    func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / avatarImageView.bounds.width
        let heightScale = size.height / avatarImageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    private func configureViewController() {
        let backgroundView = UIView()
        view.backgroundColor = Colors.mhwhite
        view.addSubViews(scrollView, backgroundView)
        backgroundView.backgroundColor = .white
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        scrollView.backgroundColor = Colors.mhwhite
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = .normal
        scrollView.addSubViews(avatarImageView)
    }
    
    private func configureImageView() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
        
        avatarImageView.isUserInteractionEnabled = true
        
        avatarImageView.addGestureRecognizer(
            UILongPressGestureRecognizer(
                target: self,
                action: #selector(longTapped)
            )
        )
    }
    
    @objc private func longTapped() {
        present(
            UIActivityViewController(
                activityItems: [avatarImageView.image ?? Images.placeholder],
                applicationActivities: nil),
            animated: true
        )
    }
}

extension FullScreenAvatarViewController: FullScreenAvatarViewable {
    func set(withModel model: FullScreenAvatarViewModel) {
        if let image = UIImage(data: model.avatar) {
            avatarImageView.image = image
        } else {
            avatarImageView.image = Images.placeholder
        }
        scrollView.contentSize = avatarImageView.image!.size
    }
    
    func showAllert(title: String?, message: String?, buttonTitle: String?) {
        presentAlertControllerOnMainTread(
            title: title ?? "",
            message: message ?? "",
            buttonTitle: buttonTitle ?? ""
        )
    }
}

extension FullScreenAvatarViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        avatarImageView
    }
}
