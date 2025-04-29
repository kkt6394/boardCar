//
//  signUpViewController.swift
//  kickBoardApp
//
//  Created by 최영건 on 4/28/25.
//

import UIKit
import SnapKit

class signupViewController: UIViewController {
    
    let fitstLabel = UILabel()
    let emailLabel = UILabel()
    let passwordLabel = UILabel()
    let nameLabel = UILabel()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let nameTextField = UITextField()
    let signupButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        view.backgroundColor = .white
    }
    
    func setupUI() {
        
        fitstLabel.text = "회원가입을 위해\n정보를 입력해주세요"
        fitstLabel.textAlignment = .left
        fitstLabel.numberOfLines = 0
        fitstLabel.font = UIFont(name: "SUIT-Regular", size: 30)
        
        emailLabel.text = "이메일을 입력해주세요."
        emailLabel.font = UIFont(name: "SUIT-SemiBold", size: 15)
        
        emailTextField.placeholder = "이메일"
//        emailTextField.layer.borderColor =
        emailTextField.borderStyle = .roundedRect
        
        passwordLabel.text = "비밀번호를 입력해주세요."
        passwordLabel.font = UIFont(name: "SUIT-SemiBold", size: 15)
        
        passwordTextField.placeholder = "비밀번호"
//        passwordTextField.layer.borderColor =
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        nameLabel.text = "이름을 입력해주세요."
        nameLabel.font = UIFont(name: "SUIT-SemiBold", size: 15)
        
        nameTextField.placeholder = "이름"
//        nameTextField.layer.borderColor =
        nameTextField.borderStyle = .roundedRect
        
        signupButton.setTitle("회원가입", for: .normal)
        signupButton.layer.borderWidth = 1
        signupButton.layer.cornerRadius = 22
        signupButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signupButton.addTarget(self, action: #selector(signup), for: .touchUpInside)

        // 뷰에 추가
        [fitstLabel, emailTextField, emailLabel, passwordLabel, nameLabel, passwordTextField, nameTextField, signupButton].forEach {
            view.addSubview($0)
        }

        // SnapKit 제약 설정
        fitstLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(180)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(fitstLabel.snp.bottom).offset(35)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        

        emailTextField.snp.makeConstraints {
            $0.top.equalTo(fitstLabel.snp.bottom).offset(65)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(44)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }

        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(45)
            $0.leading.trailing.equalTo(emailTextField)
            $0.height.equalTo(44)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }

        nameTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(45)
            $0.leading.trailing.equalTo(emailTextField)
            $0.height.equalTo(44)
        }

        signupButton.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(45)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(200)
        }
    }
    
    struct User: Codable {
        let email: String
        let password: String
        let name: String
    }
    
    @objc func signup() {
        guard let email = emailTextField.text,  // guard let은 안전하게 값이 있는지 확인하는 코드이다.
              let password = passwordTextField.text,
              let name = nameTextField.text,
              !email.isEmpty, !password.isEmpty, !name.isEmpty else { // 하나라도 빈칸이면 얼럿 함수로 에러 메시지 표시
            showAlert(message: "아이디 또는 비밀번호를 다시 확인해주세요.")
            return
        }
        
        let newUser = User(email: email, password: password, name: name) // 새로 입력된 데이터를 바탕으로 User 구조체를 만든 것.
        
        var savedUsers: [User] = [] // 만약 저장된 게 없으면 빈 배열으로 시작한다.
        if let data = UserDefaults.standard.data(forKey: "savedUsers"), // UserDefaults에 저장된 사용자 목록이 있으면 data에서 꺼내고
           let decoded = try? JSONDecoder().decode([User].self, from: data) { // JSONDecoder를 사용해서 [User] 배열으로 변환해주는 코드
            savedUsers = decoded
        }
        
        if savedUsers.contains(where: { $0.email == email }) { // 기존 사용자 중에서 똑같은 이메일을 가진 사용자가 있는지 확인하는 코드
            showAlert(message: "이미 등록된 이메일입니다.") // 똑같은 이메일의 사용자가 존재한다면 회원가입을 못 하게 막고 알림을 유저에게 띄운다.
            return
        }
        
        savedUsers.append(newUser)
        if let encoded = try? JSONEncoder().encode(savedUsers) {
            UserDefaults.standard.set(encoded, forKey: "savedUsers")
            // 새 사용자를 배열에 추가하고 JSONEncoder으로 [User]를 data으로 인코딩한 후 UserDefaults에 저장하는 메서드
        }
        
        print("회원가입 완료! 저장된 사용자 목록:")
        savedUsers.forEach { user in
            print("이메일: \(user.email), 이름: \(user.name)")
        }
        
        func loadUserDatas() -> [User] {
            if let data = UserDefaults.standard.data(forKey: "savedUsers"),
               let users = try? JSONDecoder().decode([User].self, from: data) {
                return users
            }
            return []
        }
        
        
        
 
        
        
        
        // 회원가입 완료 후 로그인 화면으로 돌아가기
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "완료", style: .default))
        present(alert, animated: true)
    }
}
