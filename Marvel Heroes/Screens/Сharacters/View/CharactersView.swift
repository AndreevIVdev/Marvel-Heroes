//
//  CharacterView.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 02.12.2021.
//

import UIKit

protocol CharacterViewable: AnyObject {
    func showAllert(title: String?, message: String?, buttonTitle: String?)
}

class CharacterViewController: MHDataLoadingViewController, CharacterViewable {
    
    var presenter: ChractersPresentable!
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubViews(tableView)
        configureViewController()
        configureTableView()
        getCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func getCharacters() {
        showLoadingView()
        DispatchQueue.global().async {
            self.presenter.fetchCharacters { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.dismissLoadingView()
                }
            }
        }
    }
    
    private func configureViewController() {
        view.backgroundColor = Colors.mhwhite
        title = "Characters"
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = .init(
            title: "Log out",
            style: .plain,
            target: self,
            action: #selector(logOutButtonTapped)
        )
    }
    
    private func configureTableView() {
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MHTableViewCell.self, forCellReuseIdentifier: MHTableViewCell.description())
    }
    
    func showAllert(title: String?, message: String?, buttonTitle: String?) {
        presentAlertControllerOnMainTread(
            title: title ?? "",
            message: message ?? "",
            buttonTitle: buttonTitle ?? ""
        )
    }
    
    @objc private func logOutButtonTapped() {
        presenter.logOutButtonTapped()
    }
}

extension CharacterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectRowAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getCharactersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MHTableViewCell.description(),
            for: indexPath
        ) as! MHTableViewCell
        
        cell.id = UUID()
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.presenter.getModel(forIndex: indexPath.row) { [weak cell, id = cell.id] model in
                guard let cell = cell,
                      cell.id == id else { return }
                DispatchQueue.main.async {
                    cell.nameLabel.text = model.name
                    if let data = model.avatar {
                        cell.avatarImageView.image = UIImage(data: data)
                    }
                }
            }
        }
        return cell
    }
}

extension CharacterViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            getCharacters()
        }
    }
}
