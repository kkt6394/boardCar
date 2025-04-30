//
//  TableViewCell.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/28/25.
//

import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    
    static let id = "TableViewCell"
    
    // 테이블 뷰 섹션 케이스별 정리
    enum TableViewSections: Int, CaseIterable {
        case nameSection
        case pointSection
        case historySection
        case shareInfoSection
        case adSection
    }
    enum Cell {
        case name
        case point
        case history
        case shareInfo
        case ad
    }
    // 첫 번째 셀에 들어갈 객체
    let helmetImageView = UIImageView()
    let nameLabel = UILabel()
    let greetingLabel = UILabel()
    
    // 두 번째 셀에 들어갈 객체
    let pointLabel = UILabel()
    let pointImageView = UIImageView()
    let myPointLabel = UILabel()
    
    // 세 번째 셀에 들어갈 객체
    let borrowImage = UIImageView()
    let borrowLabel = UILabel()
    let shareImage = UIImageView()
    let shareLabel = UILabel()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(type: Cell) {
        [helmetImageView, nameLabel, greetingLabel, pointLabel, pointImageView, myPointLabel,borrowImage, borrowLabel, shareImage, shareLabel].forEach { $0.isHidden = true }
        switch type {
        case .name:
            helmetImageView.isHidden = false
            nameLabel.isHidden = false
            greetingLabel.isHidden = false
            helmetImageView.image = UIImage(named: "helmet")
            nameLabel.text = "최영건님,"
            nameLabel.font = UIFont(name: "GmarketSansMedium", size: 18)
            greetingLabel.text = "오늘도 안전 운전하세요!"
            greetingLabel.font = UIFont(name: "GmarketSansMedium", size: 16)
        case .point:
            pointLabel.isHidden = false
            pointImageView.isHidden = false
            myPointLabel.isHidden = false
            pointLabel.text = "내 포인트"
            pointImageView.image = UIImage(named: "coin")
            myPointLabel.text = "2,000"
        case .history:
            borrowImage.isHidden = false
            borrowLabel.isHidden = false
            shareImage.isHidden = false
            shareLabel.isHidden = false
            borrowImage.image = UIImage(named: "wheel")
        case .shareInfo:
            break
        case .ad:
            break
        }
    }
    private func setupView() {
        [
            helmetImageView, nameLabel, greetingLabel, pointLabel, pointImageView, myPointLabel
        ].forEach { contentView.addSubview($0) }
        
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
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.trailing.equalTo(myPointLabel.snp.leading).offset(16)
            // 수정해야함
        }
        
    }
}
