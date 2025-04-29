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
    let currentButton = UIButton()
    
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
        
        tableView.layer.borderWidth = 1.0
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.cornerRadius = 20
        tableView.backgroundColor = UIColor.sub3
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        currentButton.setImage(UIImage(named: "newCurrentLocationBtn"), for: .normal)
        addSubview(currentButton)

        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.bottom.equalToSuperview().inset(120)
            $0.top.equalToSuperview().offset(600)
        }
        
        currentButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(34)
            $0.top.equalToSuperview().inset(550)
            $0.size.equalTo(46)
        }
        
    }
    
    @objc func currentButtonTapped() {
        
    }
}
