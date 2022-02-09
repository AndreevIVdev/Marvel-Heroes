//
//  FavoritesViewController.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 04.01.2022.
//

import UIKit

protocol FavoritesViewable: AnyObject {
    func showAllert(title: String?, message: String?, buttonTitle: String?)
    func showEmptyStateView()
    func showTableView()
    func deleteRows(at indexPath: IndexPath)
    func insertRows(at indexPath: IndexPath)
    func reloadData()
    func startIndicator()
    func stopIndicator()
}

class FavoritesViewController: MHDataLoadingViewController {
    
    var presenter: FavoritesPresentable!
    
    private let tableView: UITableView = .init()
    private let emptyStateView: MHEmptyStateView = .init(message: "No favorites")
    
    private var dragInitialIndexPath: IndexPath?
    private var dragCellSnapshot: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureEmptyStateView()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
        DispatchQueue.global().async {
            self.presenter.fetchFavorites()
        }
    }
    
    private func configureViewController() {
        view.addSubViews(tableView, emptyStateView)
        view.backgroundColor = Colors.mhwhite
        title = "Favorites"
    }
    
    private func configureTableView() {
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            MHTableViewCell.self,
            forCellReuseIdentifier: MHTableViewCell.description()
        )
        tableView.addGestureRecognizer(UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPressGesture)
        ))
    }
    
    private func configureEmptyStateView() {
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FavoritesViewController {
    // swiftlint:disable:next cyclomatic_complexity
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        let gestureLocation = gesture.location(in: tableView)
        
        switch gesture.state {
        case .began:
            guard let indexPath = tableView.indexPathForRow(at: gestureLocation) else { return }
            let cell = tableView.cellForRow(at: indexPath) as! MHTableViewCell
            dragCellSnapshot = cell.getSnapshot(inputView: cell)
            guard dragCellSnapshot != nil else { return }
            dragInitialIndexPath = indexPath
            var center = cell.center
            dragCellSnapshot!.center = center
            dragCellSnapshot!.alpha = 0.0
            tableView.addSubview(dragCellSnapshot!)
            
            UIView.animate(
                withDuration: 0.25,
                animations: {
                    center.y = gestureLocation.y
                    self.dragCellSnapshot?.center = center
                    self.dragCellSnapshot?.transform = (self.dragCellSnapshot?.transform.scaledBy(x: 1.05, y: 1.05))!
                    self.dragCellSnapshot?.alpha = 0.99
                    cell.alpha = 0.0
                },
                completion: { finished in
                    if finished {
                        cell.isHidden = true
                    }
                }
            )
            
        case .changed:
            guard let indexPath = tableView.indexPathForRow(at: gestureLocation) else { return }
            guard dragInitialIndexPath != nil,
                  dragCellSnapshot != nil else { return }
            
            var center = dragCellSnapshot!.center
            center.y = gestureLocation.y
            dragCellSnapshot!.center = center
            if indexPath != dragInitialIndexPath {
                presenter.moveModel(from: dragInitialIndexPath!.row, to: indexPath.row)
                tableView.moveRow(at: dragInitialIndexPath!, to: indexPath)
                dragInitialIndexPath = indexPath
            }
            
        case .ended where dragInitialIndexPath != nil:
            guard let cell = tableView.cellForRow(at: dragInitialIndexPath!) else { return }
            cell.isHidden = false
            cell.alpha = 0.0
            UIView.animate(
                withDuration: 0.25,
                animations: {
                    self.dragCellSnapshot?.center = cell.center
                    self.dragCellSnapshot?.transform = CGAffineTransform.identity
                    self.dragCellSnapshot?.alpha = 0.0
                    cell.alpha = 1.0
                },
                completion: { finished in
                    if finished {
                        self.dragInitialIndexPath = nil
                        self.dragCellSnapshot?.removeFromSuperview()
                        self.dragCellSnapshot = nil
                    }
                })
            
        default: return
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getFavoritesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MHTableViewCell.description(),
            for: indexPath
        ) as! MHTableViewCell
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.presenter.getModel(forRow: indexPath.row) { [weak cell, id = cell.id] model in
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        presenter.deleteRowAt(indexPath: indexPath)
    }
}

extension FavoritesViewController: FavoritesViewable {
    
    func showAllert(title: String?, message: String?, buttonTitle: String?) {
        presentAlertControllerOnMainTread(
            title: title ?? "",
            message: message ?? "",
            buttonTitle: buttonTitle ?? ""
        )
    }
    
    func showEmptyStateView() {
        DispatchQueue.main.async {
            self.view.bringSubviewToFront(self.emptyStateView)
        }
    }
    
    func deleteRows(at indexPath: IndexPath) {
        tableView.deleteRows(
            at: [indexPath],
            with: .automatic
        )
    }
    
    func insertRows(at indexPath: IndexPath) {
        tableView.insertRows(
            at: [indexPath],
            with: .automatic
        )
    }
    
    func showTableView() {
        DispatchQueue.main.async {
            self.view.bringSubviewToFront(self.tableView)
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func startIndicator() {
        DispatchQueue.main.async {
            self.showLoadingView()
        }
    }
    
    func stopIndicator() {
        DispatchQueue.main.async {
            self.dismissLoadingView()
        }
    }
}
