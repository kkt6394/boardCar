//
//  historyCell.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/30/25.
//

import Foundation
import UIKit

class HistoryCell: UITableViewCell {
    static let id = "HistoryCell"
    
    let borrowImage = UIImageView()
    let borrowLabel = UILabel()
    let shareImage = UIImageView()
    let shareLabel = UILabel()

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
            borrowImage,
            borrowLabel,
            shareImage,
            shareLabel
        ].forEach { contentView.addSubview($0) }
        borrowImage.image = UIImage(named: "wheel")
        borrowLabel.text = "킥보드 대여 횟수 : 6회"
        borrowLabel.font = UIFont(name: "SUIT-Regular", size: 14)
        shareImage.image = UIImage(named: "coin2")
        shareLabel.text = "최영건님의 킥보드는 2회 대여되었어요!"
        shareLabel.font = UIFont(name: "SUIT-Regular", size: 14)
        
    }
    
    private func setupConstraints() {
        borrowImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(8)
        }
        borrowLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalTo(borrowImage.snp.trailing).offset(8)
        }
        shareImage.snp.makeConstraints {
            $0.top.equalTo(borrowImage.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.leading.equalToSuperview().offset(8)
            
        }
        shareLabel.snp.makeConstraints {
            $0.top.equalTo(borrowLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.leading.equalTo(shareImage.snp.trailing).offset(8)
        }
    }
}

