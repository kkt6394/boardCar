//
//  LoginView.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/28/25.
//

import UIKit
import SnapKit

class LoginView: UIView {
    
    weak var delegate: LoginViewDelegate?
    // 이 클래스는 UIView, 어느 뷰 컨트롤러에서 작동할 지 정해야함.
    weak var loginVC: LoginVC?
    
    private let logo = UIImageView()
    private let idTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let findButton = UIButton()
    private let stackView = UIStackView()
    private let coinImage = UIImageView()
    private let pointLabel = UILabel()
    private let joinButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: UI 설정 메서드
    private func setupUI() {
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
        idTextField.layer.borderColor = UIColor.main.cgColor
        idTextField.backgroundColor = UIColor.sub3
        
        //MARK: password 텍스트 필드 UI
        passwordTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        passwordTextField.leftViewMode = .always

        passwordTextField.placeholder = "비밀번호"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.font = UIFont(name: "SUIT-SemiBold", size: 16)
        passwordTextField.layer.cornerRadius = 13.0
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor.main.cgColor
        passwordTextField.backgroundColor = UIColor.sub3

        
        //MARK: 로그인 버튼 UI
        loginButton.setTitle("로그인", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "SUIT-Thin", size: 20)
        loginButton.backgroundColor = UIColor.main
        loginButton.layer.cornerRadius = 13.0
        loginButton.clipsToBounds = true
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
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
        joinButton.backgroundColor = UIColor.font2
        joinButton.layer.cornerRadius = 8.0
        joinButton.clipsToBounds = true
        joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
    }
    
    //MARK: 제약 설정 메서드
    private func setupConstraints() {
        
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
    @objc
    func loginButtonTapped() {
        guard let email = idTextField.text,
              let password = passwordTextField.text,
              !email.isEmpty, !password.isEmpty else {
            delegate?.showAlert(message: "이메일과 비밀번호를 입력해주세요.")
            return
        }
        
        let savedUsers = loadUserData()
        print("불러온 사용자 목록: \(savedUsers)")
        
        if let matchedUser = savedUsers.first(where: { $0.email == email && $0.password == password}) {
            delegate?.showAlert(message: "\(matchedUser.name)님, 환영합니다!")
            UserDefaults.standard.set(matchedUser.email, forKey: "currentUserEmail")
                let nextVC = UnderTabBarController()
                self.loginVC?.navigationController?.pushViewController(nextVC, animated: true)

            
        
        } else {
            delegate?.showAlert(message: "이메일 또는 비밀번호가 일치하지 않습니다.")
        }
        
        
        print("clicked")

    }
    func loadUserData() -> [User] {
        if let data = UserDefaults.standard.data(forKey: "savedUsers"),
           let users = try? JSONDecoder().decode([User].self, from: data) {
            return users
        }
        return []
    }
    @objc
    func joinButtonTapped() {
        print("clicked")
        let nextVC = signupViewController()
        loginVC?.navigationController?.pushViewController(nextVC, animated: true)

    }
    

}
