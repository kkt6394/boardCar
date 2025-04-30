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
        case historyBorrow
        case historyShare
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
    
    // 네 번째 셀에 들어갈 객체
    let kickBoardImage = UIImageView()
    let kickBoardNameLabel = UILabel()
    let periodLabel = UILabel()
    
    // 다섯 번째 셀에 들어갈 객체
    let ad = UIImageView()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(type: Cell) {
        [helmetImageView, nameLabel, greetingLabel, pointLabel, pointImageView, myPointLabel, borrowImage, borrowLabel, shareImage, shareLabel, kickBoardImage, kickBoardNameLabel, periodLabel, ad].forEach { $0.isHidden = true }
        
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
            pointLabel.font = UIFont(name: "SUIT-Bold", size: 18)
            pointImageView.image = UIImage(named: "coin")
            myPointLabel.text = "2,000"
            myPointLabel.font = UIFont(name: "SUIT-SemiBold", size: 18)
        case .historyBorrow:
            borrowImage.isHidden = false
            borrowLabel.isHidden = false
            borrowImage.image = UIImage(named: "wheel")
            borrowLabel.text = "킥보드 대여 횟수 : 6회"
            borrowLabel.font = UIFont(name: "SUIT-Regular", size: 14)

        case .historyShare:
            shareImage.isHidden = false
            shareLabel.isHidden = false
            shareImage.image = UIImage(named: "coin2")
            shareLabel.text = "최영건님의 킥보드는 2회 대여되었어요!"
            shareLabel.font = UIFont(name: "SUIT-Regular", size: 14)

        case .shareInfo:
            kickBoardImage.isHidden = false
            kickBoardNameLabel.isHidden = false
            periodLabel.isHidden = false
            kickBoardImage.image = UIImage(named: "kickBoard")
            kickBoardNameLabel.text = "최애 붕붕이"
            kickBoardNameLabel.font = UIFont(name: "SUIT-SemiBold", size: 18)
            periodLabel.text = "2025. 02. 03 ~ 2026. 01. 04"
            periodLabel.font = UIFont(name: "SUIT-Regular", size: 12)
            
        case .ad:
            ad.isHidden = false
            ad.image = UIImage(named: "ad")
        }
    }
    private func setupView() {
        [
            helmetImageView, nameLabel, greetingLabel, pointLabel, pointImageView, myPointLabel, borrowImage, borrowLabel, shareImage, shareLabel, kickBoardImage,kickBoardNameLabel, periodLabel, ad
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
            $0.centerY.equalTo(myPointLabel.snp.centerY)
            $0.trailing.equalTo(myPointLabel.snp.leading).offset(-16)
        }
        borrowImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().offset(8)
        }
        borrowLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.equalTo(borrowImage.snp.trailing).offset(8)
        }
        shareImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().offset(8)
        }
        shareLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.equalTo(shareImage.snp.trailing).offset(8)
        }
        kickBoardImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(10)
        }
        kickBoardNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(kickBoardImage.snp.centerY)
            $0.leading.equalTo(kickBoardImage.snp.trailing).offset(20)
        }
        periodLabel.snp.makeConstraints {
            $0.top.equalTo(kickBoardNameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(kickBoardImage.snp.trailing).offset(20)
        }
        ad.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
