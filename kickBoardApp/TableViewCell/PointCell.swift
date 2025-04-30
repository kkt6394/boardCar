//
//  pointCell.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/30/25.
//

import Foundation
import UIKit

class PointCell: UITableViewCell {
    static let id = "PointCell"
    
    let pointLabel = UILabel()
    let pointImageView = UIImageView()
    let myPointLabel = UILabel()
    
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
            pointLabel,
            pointImageView,
            myPointLabel
        ].forEach { contentView.addSubview($0) }
//        pointLabel.isHidden = false
//        pointImageView.isHidden = false
//        myPointLabel.isHidden = false
        pointLabel.text = "내 포인트"
        pointLabel.font = UIFont(name: "SUIT-Bold", size: 18)
        pointImageView.image = UIImage(named: "coin")
        myPointLabel.text = "2,000"
        myPointLabel.font = UIFont(name: "SUIT-SemiBold", size: 18)
    }
    private func setupConstraints() {
        pointLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().offset(10)
        }
        myPointLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(16)
        }
        pointImageView.snp.makeConstraints {
            $0.centerY.equalTo(myPointLabel.snp.centerY)
            $0.trailing.equalTo(myPointLabel.snp.leading).offset(-16)
        }
    }
}

