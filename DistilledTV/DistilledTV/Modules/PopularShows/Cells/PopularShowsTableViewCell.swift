//
//  ShowTableViewCell.swift
//  DistilledTV
//
//  Created by Barry on 20/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import UIKit

class PopularShowsTableViewCell: UITableViewCell {
    
    private var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = lbl.font.withSize(24.0)
        return lbl
    }()
    
    private var overviewLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = lbl.font.withSize(12.0)
        return lbl
    }()
    
    public var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        selectionStyle = .none
        contentView.addSubview(posterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(overviewLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        posterImageView.leading(to: contentView, offset: 16.0)
        posterImageView.top(to: contentView, offset: 10.0)
        posterImageView.height(80.0)
        posterImageView.width(80.0)
        
        nameLabel.leadingToTrailing(of: posterImageView, offset: 10.0)
        nameLabel.trailing(to: contentView, offset: 10.0)
        nameLabel.centerY(to: posterImageView)
        
        overviewLabel.leading(to: contentView, offset: 16.0)
        overviewLabel.topToBottom(of: posterImageView, offset: 10.0)
        overviewLabel.trailing(to: contentView, offset: -16.0)
        overviewLabel.bottom(to: contentView, offset: -10.0)
    }
    
    public func configure(_ show: PopularShow) {
        nameLabel.text = show.name
        overviewLabel.text = show.overview
    }
}


