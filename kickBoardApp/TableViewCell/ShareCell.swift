//
//  shareCell.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/30/25.
//

import Foundation
import UIKit

class ShareCell: UITableViewCell {
    static let id = "ShareCell"
    
    private let kickBoardImage = UIImageView()
    private let kickBoardNameLabel = UILabel()
    private let periodLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConfigure()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupConfigure() {
        [kickBoardImage, stackView]
            .forEach { contentView.addSubview($0) }
        [kickBoardNameLabel, periodLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.axis = .vertical
        stackView.alignment = .leading
        kickBoardImage.image = UIImage(named: "kickBoard")
        kickBoardNameLabel.text = "최애 붕붕이"
        kickBoardNameLabel.font = UIFont(name: "SUIT-SemiBold", size: 18)
        periodLabel.text = "2025. 02. 03 ~ 2026. 01. 04"
        periodLabel.font = UIFont(name: "SUIT-Regular", size: 12)
    }
    private func setupConstraints() {
        kickBoardImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(10)
        }
        stackView.snp.makeConstraints {
            $0.centerY.equalTo(kickBoardImage.snp.centerY)
            $0.leading.equalTo(kickBoardImage.snp.trailing).offset(20)
        }
    }
    
}

