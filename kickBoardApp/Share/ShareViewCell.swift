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
        
//        // 킥보드 이름 UITextField
//        [kickBoardName, sharedButton].forEach { addSubview($0) }
//        
//        kickBoardName.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
//        kickBoardName.leftViewMode = .always
//        kickBoardName.placeholder = "킥보드 이름"
////        kickBoardName.font = UIFont(name: <#T##String#>, size: <#T##CGFloat#>)
//        kickBoardName.layer.cornerRadius = 13.0
//        kickBoardName.layer.borderWidth = 1.0
//        kickBoardName.layer.borderColor = UIColor.brown.cgColor
//        kickBoardName.backgroundColor = .white
//        
//        // 내 킥보드 공유하기 UIButton
//        sharedButton.setTitle("내 킥보드 공유하기", for: .normal)
////        sharedButton.titleLabel?.font =
//        sharedButton.backgroundColor = .purple
//        sharedButton.layer.cornerRadius = 13.0
//        sharedButton.clipsToBounds = true
//        
//        kickBoardName.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(5)
//            $0.leading.trailing.equalToSuperview().inset(5)
////            $0.bottom.equalTo(pickerViewTableCell.snp.top).offset(5)
//        }
//        
//        sharedButton.snp.makeConstraints {
////            $0.top.equalTo(pickerViewTableCell.snp.bottom).offset(5)
//            $0.leading.trailing.equalToSuperview().inset(5)
//            $0.bottom.equalToSuperview().inset(5)
//        }
//        
    }
    
    
}
