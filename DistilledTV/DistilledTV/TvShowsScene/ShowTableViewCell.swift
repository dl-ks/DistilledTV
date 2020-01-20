//
//  ShowTableViewCell.swift
//  DistilledTV
//
//  Created by Barry on 20/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import UIKit

class ShowTableViewCell: UITableViewCell {
    
//    private let titleLabel = UILabel()
//    private let overviewLabel = UILabel()
//    private let posterImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(overviewLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private var overviewLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = lbl.font.withSize(12.0)
        return lbl
    }()
    
    private var posterImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    func setupConstraints() {
        posterImageView.leading(to: contentView, offset: 16.0)
        posterImageView.centerY(to: contentView)
        posterImageView.height(60.0)
        posterImageView.width(60.0)
        
        nameLabel.leadingToTrailing(of: posterImageView, offset: 16.0)
        nameLabel.trailing(to: contentView, offset: 10.0)
        nameLabel.top(to: contentView, offset: 10.0)
        
        overviewLabel.leftToRight(of: posterImageView, offset: 16.0)
        overviewLabel.topToBottom(of: nameLabel, offset: 10.0)
        overviewLabel.right(to: contentView)
        overviewLabel.bottom(to: contentView, offset: -10.0)
    }
    
}

extension ShowTableViewCell {
    
    func configure(_ show: Show) {
        nameLabel.text = show.name
        nameLabel.sizeToFit()
        overviewLabel.text = show.overview
    }
    
}
