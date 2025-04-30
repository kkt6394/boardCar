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
    
    public let mapView = NMFMapView()
    
    public let tableView = UITableView()
    public let currentButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        currentButton.addTarget(self, action: #selector(currentButtonTapped), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        [mapView, tableView, currentButton].forEach { addSubview($0) }
        
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.layer.borderWidth = 1.0
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.cornerRadius = 20
        tableView.backgroundColor = UIColor.sub3
        
        currentButton.setImage(UIImage(named: "newCurrentLocationBtn"), for: .normal)

        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.bottom.equalToSuperview().inset(120)
            $0.height.equalTo(156)
        }
        
        currentButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(34)
            $0.bottom.equalTo(tableView.snp.top).offset(-20)
            $0.size.equalTo(46)
        }
        
    }
    
    @objc func currentButtonTapped() {
        print("현재위치 버튼이 눌렸습니다")
    }
    
}


