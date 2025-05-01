//
//  nameCell.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/30/25.
//

import Foundation
import UIKit

class NameCell: UITableViewCell {
    static let id = "NameCell"
    
    let helmetImageView = UIImageView()
    let nameLabel = UILabel()
    let greetingLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConfigure()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConfigure() {
        [
            helmetImageView,
            nameLabel,
            greetingLabel
        ].forEach { contentView.addSubview($0) }
        helmetImageView.image = UIImage(named: "helmet")
        nameLabel.text = "최영건님,"
        nameLabel.font = UIFont(name: "GmarketSansMedium", size: 18)
        greetingLabel.text = "오늘도 안전 운전하세요!"
        greetingLabel.font = UIFont(name: "GmarketSansMedium", size: 16)

    }
    private func setupConstraints() {
        helmetImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(4)
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().inset(8)
        }
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(helmetImageView.snp.trailing).offset(16)
            $0.top.equalToSuperview().offset(36)
        }
        greetingLabel.snp.makeConstraints {
            $0.leading.equalTo(helmetImageView.snp.trailing).offset(16)
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
    }
    func configure(with user: User) {
        nameLabel.text = "\(user.name)님,"
    }
}

