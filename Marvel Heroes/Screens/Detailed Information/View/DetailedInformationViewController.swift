//
//  DetailedInformationViewController.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 02.01.2022.
//

import UIKit
protocol DetailedInformationViewable: AnyObject {
    func showAllert(title: String?, message: String?, buttonTitle: String?)
    func setFavoriteButton(isInFavorites: Bool)
    func present(toPresent: UIViewController)
}

class DetailedInformationViewController: UIViewController {
    private let scrollView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let headerView: UIView = .init()
    private let itemViewOne: UIView = .init()
    private let itemViewTwo: UIView = .init()
    private let copyrightLabel: MHBodyLabel = .init(textAlignment: .center)
    
    var presenter: DetailedInformationPresentable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureScrollView()
        configureContentView()
        layoutUI()
        configureUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = false
        presenter.updateIsInFavorites()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        view.addSubViews(scrollView)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Images.isNotInFavorites,
            style: .plain,
            target: self,
            action: #selector(favouriteButtonTapped)
        )
    }
    
    private func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        scrollView.addSubViews(contentView)
    }
    
    private func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func layoutUI() {
        let padding: CGFloat = 20
        
        let itemViews = [headerView, itemViewOne, itemViewTwo, copyrightLabel]
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: 140),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: 140),
            
            copyrightLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            copyrightLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureUIElements() {
        let model = presenter.getModel()
        let infoHeaderViewController: MHCharacterInfoHeaderViewController = .init(
            avatarTapped: presenter.avatarImageTapped
        )
        let comicsItemViewController: MHItemInfoViewController = .init(actionButtonTap: presenter.comicsButtonTapped())
        
        let storiesItemViewController: MHItemInfoViewController = .init(actionButtonTap: presenter.wikiButtonTapped())
        
        infoHeaderViewController.configureUI(
            avatarURL: model.avatarURL,
            name: model.name,
            id: model.id,
            modified: model.modified,
            description: model.description
        )
        
        comicsItemViewController.itemInfoViewOne.set(itemInfoType: .comics, withCount: model.comicsCount)
        comicsItemViewController.itemInfoViewTwo.set(itemInfoType: .series, withCount: model.seriesCount)
        storiesItemViewController.itemInfoViewOne.set(itemInfoType: .stories, withCount: model.storiesCount)
        storiesItemViewController.itemInfoViewTwo.set(itemInfoType: .events, withCount: model.eventsCount)
        
        comicsItemViewController.actionButton.setTitle("Comics", for: .normal)
        storiesItemViewController.actionButton.setTitle("Wiki", for: .normal)
        
        
        add(
            childViewController: infoHeaderViewController,
            to: headerView
        )
        add(childViewController: comicsItemViewController, to: itemViewOne)
        add(childViewController: storiesItemViewController, to: itemViewTwo)
        copyrightLabel.text = "Data provided by Marvel. © 2022 MARVEL"
    }
    
    
    @objc private func favouriteButtonTapped() {
        presenter.favouriteButtonTapped()
    }
}

extension DetailedInformationViewController: DetailedInformationViewable {
    
    
    func showAllert(title: String?, message: String?, buttonTitle: String?) {
        presentAlertControllerOnMainTread(
            title: title ?? "",
            message: message ?? "",
            buttonTitle: buttonTitle ?? ""
        )
    }
    
    func setFavoriteButton(isInFavorites: Bool) {
        navigationItem.rightBarButtonItem?.image = isInFavorites ? Images.isInFavorites : Images.isNotInFavorites
    }
    
    func present(toPresent: UIViewController) {
        present(toPresent, animated: true)
    }
}
// extension ProfileViewController: GPReposItemViewControllerDelegate {
//
//    func didTapOnGitHubProfile(for user: User) {
//        guard let url = URL(string: user.htmlUrl) else {
//            presentGPAlertOnMainTread(title: "Invalid URL", message: "The url attached to this user is invalid!", buttonTitle: "Ok")
//            return
//        }
//        presentSafariViewController(with: url)
//    }
// }

// extension ProfileViewController: GPFollowersItemViewControllerDelegate {
//
//    func didTapGitFollowers(for user: User) {
//        guard user.followers != 0 else {
//            presentGPAlertOnMainTread(title: "No followers", message: "This user has no followers!", buttonTitle: "Ok")
//            return
//        }
//        navigationController?.pushViewController(FollowersListViewController(user: user), animated: true)
//    }
// }
