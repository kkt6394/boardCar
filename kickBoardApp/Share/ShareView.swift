//
//  ShareView.swift
//  kickBoardApp
//
//  Created by 김재우 on 4/28/25.
//

import UIKit
import SnapKit
import NMapsMap

class ShareView: UIView {
    
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        tableView.backgroundColor = .white
        tableView.layer.borderWidth = 1.0
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.cornerRadius = 20
        tableView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0) // 커스텀 색상
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.bottom.equalToSuperview().inset(120)
            $0.top.equalToSuperview().offset(600)
        }
        

    }
    
}
