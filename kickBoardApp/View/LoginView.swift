//
//  LoginView.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/28/25.
//

import UIKit
import SnapKit

class LoginView: UIView {
    
    let logo = UIImageView()
    let idTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    let findButton = UIButton()
    let stackView = UIStackView()
    let coinImage = UIImageView()
    let pointLabel = UILabel()
    let joinButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: UI 설정 메서드
    func setupUI() {
        self.backgroundColor = .white
        [logo,
         idTextField,
         passwordTextField,
         loginButton,
         findButton,
         stackView,
         joinButton
        ]
            .forEach { addSubview($0) }
        
        //MARK: 로고
        logo.image = UIImage(named: "logo")
        
        //MARK: id 텍스트 필드 UI
        idTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        idTextField.leftViewMode = .always
        idTextField.placeholder = "아이디"
        idTextField.font = UIFont(name: "SUIT-SemiBold", size: 16)
        idTextField.layer.cornerRadius = 13.0
        idTextField.layer.borderWidth = 1.0
        idTextField.layer.borderColor = UIColor(red: 173/255, green: 68/255, blue: 162/255, alpha: 1.0).cgColor
        idTextField.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 247/255, alpha: 1.0)
        
        //MARK: password 텍스트 필드 UI
        passwordTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        passwordTextField.leftViewMode = .always

        passwordTextField.placeholder = "비밀번호"
        passwordTextField.font = UIFont(name: "SUIT-SemiBold", size: 16)
        passwordTextField.layer.cornerRadius = 13.0
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor(red: 173/255, green: 68/255, blue: 162/255, alpha: 1.0).cgColor
        passwordTextField.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 247/255, alpha: 1.0)

        
        //MARK: 로그인 버튼 UI
        loginButton.setTitle("로그인", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "SUIT-Thin", size: 20)
        loginButton.backgroundColor = UIColor(red: 106/255, green: 44/255, blue: 112/255, alpha: 1.0)
        loginButton.layer.cornerRadius = 13.0
        loginButton.clipsToBounds = true
        
        //MARK: 아이디 / 비밀번호 찾기 UI
        findButton.setTitle("아이디 / 비밀번호 찾기", for: .normal)
        findButton.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 14)

        findButton.setTitleColor(.gray, for: .normal)
        
        //MARK: 스택뷰(코인이미지 + 포인트레이블)
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.addArrangedSubview(coinImage)
        stackView.addArrangedSubview(pointLabel)

        //MARK: 코인 이미지 UI
        coinImage.image = UIImage(named: "coin")
        
        //MARK: 포인트 레이블 UI
        pointLabel.text = "신규가입하고 2,000 포인트 받기!"
        pointLabel.font = UIFont(name: "SUIT-Extralight", size: 10)
        
        //MARK: 회원가입 버튼 UI
        joinButton.setTitle("회원가입", for: .normal)
        joinButton.titleLabel?.font = UIFont(name: "SUIT-Extralight", size: 12)
        joinButton.backgroundColor = UIColor(red: 64/255, green: 53/255, blue: 36/255, alpha: 1.0)
        joinButton.layer.cornerRadius = 8.0
        joinButton.clipsToBounds = true
    }
    
    //MARK: 제약 설정 메서드
    func setupConstraints() {
        
        //MARK: 로고 제약
        logo.snp.makeConstraints {
            $0.top.equalToSuperview().offset(186)
            $0.centerX.equalToSuperview()
        }
        //MARK: id 텍스트 필드 제약
        idTextField.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(14)
            $0.width.equalTo(350)
            $0.height.equalTo(46)
            $0.leading.equalToSuperview().offset(26)
            $0.trailing.equalToSuperview().inset(26)
        }
        //MARK: password 텍스트 필드 제약
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(20)
            $0.width.equalTo(350)
            $0.height.equalTo(46)
            $0.leading.equalToSuperview().offset(26)
            $0.trailing.equalToSuperview().inset(26)
        }
        //MARK: 로그인 버튼 제약
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(16)
            $0.width.equalTo(350)
            $0.height.equalTo(41)
            $0.leading.equalToSuperview().offset(26)
            $0.trailing.equalToSuperview().inset(26)
        }
        //MARK: 아이디 / 비밀번호 찾기 버튼 제약
        findButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        //MARK: 포인트 레이블 제약
        stackView.snp.makeConstraints {
            $0.top.equalTo(findButton.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        //MARK: 회원가입 버튼 제약
        joinButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(36)
        }
    }
}
