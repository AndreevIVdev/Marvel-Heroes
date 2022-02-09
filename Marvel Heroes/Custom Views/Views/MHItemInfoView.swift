//
//  mhItemInfoView.swift
//
//
//  Created by Илья Андреев on 02.01.2022.
//

import UIKit

enum MHItemInfoType {
    case comics, series, stories, events
}

final class MHItemInfoView: UIView {
    private let symbolImageView: UIImageView = .init()
    private let titleLabel: MHTitleLabel = .init(
        textAlignment: .left,
        fontSize: 14
    )
    private let countLabel: MHTitleLabel = .init(
        textAlignment: .left,
        fontSize: 14
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(
        itemInfoType: MHItemInfoType,
        withCount count: Int
    ) {
        switch itemInfoType {
        case .comics:
            symbolImageView.image = Images.comics
            titleLabel.text = "Comics"
        case .series:
            symbolImageView.image = Images.series
            titleLabel.text = "Series"
        case .stories:
            symbolImageView.image = Images.stories
            titleLabel.text = "Stories"
        case .events:
            symbolImageView.image = Images.events
            titleLabel.text = "Events"
        }
        countLabel.text = String(count)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubViews(symbolImageView, titleLabel, countLabel)
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor = .label
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
