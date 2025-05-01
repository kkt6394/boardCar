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
    
    let centerMark = UIImageView()
    let mapView = NMFMapView()
    let customView = UIView()
    let kickBoardName = UITextField()
    let pickerView = UIPickerView()
    let sharedButton = UIButton()
    let dateLabel = UILabel()
    let currentButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureUI()
        
        currentButton.addTarget(self, action: #selector(currentButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        configureUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        [mapView, customView, currentButton, centerMark].forEach { addSubview($0) }
        
        [kickBoardName, pickerView, sharedButton, dateLabel].forEach { customView.addSubview($0) }
        
        centerMark.image = UIImage(named: "centerMark")
        
        customView.backgroundColor = .sub3
        customView.layer.cornerRadius = 13.0
        customView.layer.borderWidth = 1.0
        customView.layer.borderColor = UIColor.font3.cgColor
        
        kickBoardName.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        kickBoardName.leftViewMode = .always
        kickBoardName.placeholder = "킥보드 이름"
        kickBoardName.font = UIFont(name: "SUIT-Regular", size: 16)
        kickBoardName.layer.cornerRadius = 13.0
        kickBoardName.layer.borderWidth = 1.0
        kickBoardName.layer.borderColor = UIColor.font3.cgColor
        kickBoardName.backgroundColor = .white
        kickBoardName.isUserInteractionEnabled = true
        
        pickerView.backgroundColor = .white
        pickerView.layer.borderWidth = 1.0
        pickerView.layer.borderColor = UIColor.font3.cgColor
        pickerView.layer.cornerRadius = 13.0
        
        sharedButton.setTitle("내 킥보드 공유하기", for: .normal)
        sharedButton.titleLabel?.font = UIFont(name: "SUIT-Heavy", size: 18)
        sharedButton.backgroundColor = UIColor.main
        sharedButton.layer.cornerRadius = 13.0
        sharedButton.clipsToBounds = true
        
        dateLabel.text = "까지"
        dateLabel.font = UIFont(name: "SUIT-Regular", size: 16)
        
        currentButton.setImage(UIImage(named: "newCurrentLocationBtn"), for: .normal)
        
    }
    
    private func configureUI() {
        
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        centerMark.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        customView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(200)
            $0.bottom.equalToSuperview().inset(94)
        }
        
        currentButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(34)
            $0.bottom.equalTo(customView.snp.top).offset(-20)
            $0.size.equalTo(46)
        }
        
        kickBoardName.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.equalToSuperview().inset(8)
            $0.height.equalTo(36)
        }
        
        pickerView.snp.makeConstraints {
            $0.top.equalTo(kickBoardName.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(48)
            $0.height.equalTo(50)
        }
        
        sharedButton.snp.makeConstraints {
            $0.top.equalTo(pickerView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(41)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(pickerView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalTo(pickerView)
        }
        
    }

    
    @objc func currentButtonTapped() {
        print("현재위치 버튼이 눌렸습니다")
    }
        
}
    







