//
//  ShareCell.swift
//  kickBoardApp
//
//  Created by 김재우 on 4/28/25.
//

import UIKit
import SnapKit

class ShareViewCell: UITableViewCell {
    
    let kickBoardName = UITextField()
    let pickerView = UIPickerView()
    let sharedButton = UIButton()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCell()
    }
    
    private func setUpCell() {
        
        [kickBoardName, pickerView, sharedButton].forEach { contentView.addSubview($0) }
        // 킥보드 이름 UITextField
        kickBoardName.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        kickBoardName.leftViewMode = .always
        kickBoardName.placeholder = "킥보드 이름"
        kickBoardName.font = UIFont(name: "SUIT-Regular", size: 16)
        kickBoardName.layer.cornerRadius = 13.0
        kickBoardName.layer.borderWidth = 1.0
        kickBoardName.layer.borderColor = UIColor.black.cgColor
        kickBoardName.backgroundColor = .white
        
        pickerView.backgroundColor = .systemGray6
        pickerView.backgroundColor = .white
        pickerView.layer.borderWidth = 1.0
        pickerView.layer.borderColor = UIColor.black.cgColor
        pickerView.layer.cornerRadius = 13.0
        
        // 내 킥보드 공유하기 UIButton
        sharedButton.setTitle("내 킥보드 공유하기", for: .normal)
        sharedButton.titleLabel?.font = UIFont(name: "SUIT-Heavy", size: 18)
        sharedButton.backgroundColor = .purple
        sharedButton.layer.cornerRadius = 13.0
        sharedButton.clipsToBounds = true
        
        kickBoardName.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(36)
        }
        
        pickerView.snp.makeConstraints {
            $0.top.equalTo(kickBoardName.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(45)
        }
        
        sharedButton.snp.makeConstraints {
            $0.top.equalTo(pickerView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(41)
            $0.bottom.equalToSuperview().inset(8)
        }
        
    }
    
}
