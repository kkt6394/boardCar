//
//  adCell.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/30/25.
//

import Foundation
import UIKit

class AdCell: UITableViewCell {
    static let id = "AdCell"
    
    let ad = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConfigure()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupConfigure() {
        [ad].forEach { contentView.addSubview($0) }
        ad.image = UIImage(named: "ad")


    }
    private func setupConstraints() {
        ad.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

    }
}
