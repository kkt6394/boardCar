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
        
        fitstLabel.text = "회원가입을 위해 정보를 입력해주세요"
        fitstLabel.textAlignment = .center
        fitstLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        emailTextField.placeholder = "이메일"
        emailTextField.borderStyle = .roundedRect
        
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        nameTextField.placeholder = "이름"
        nameTextField.borderStyle = .roundedRect
        
        signupButton.setTitle("회원가입", for: .normal)
        signupButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signupButton.addTarget(self, action: #selector(signup), for: .touchUpInside)

        // 뷰에 추가
        [fitstLabel, emailTextField, passwordTextField, nameTextField, signupButton].forEach {
            view.addSubview($0)
        }

        // SnapKit 제약 설정
        fitstLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(180)
            make.leading.trailing.equalToSuperview().inset(30)
        }

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(fitstLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(44)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(15)
            make.leading.trailing.equalTo(emailTextField)
            make.height.equalTo(44)
        }

        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(15)
            make.leading.trailing.equalTo(emailTextField)
            make.height.equalTo(44)
        }

        signupButton.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
    }

    
    
    
    @objc func signup() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let name = nameTextField.text,
              !email.isEmpty, !password.isEmpty, !name.isEmpty else {
            showAlert(message: "아이디 또는 비밀번호를 다시 확인해주세요.")
            return
        }
        
        // 새로 입력한 user 정보를 받는 코드이다.
        let newUser: [String: String] = [
            "email": email,
            "password": password,
            "name": name
        ]
        
        // 기존에 저장된 사용자 목록을 불러오는 코드
        var savedUsers = UserDefaults.standard.array(forKey: "savedUsers") as? [[String: String]] ?? []
        
        // 새로운 사용자를 추가
        savedUsers.append(newUser)
        
        // 다시 저장하기
        UserDefaults.standard.set(savedUsers, forKey: "savedUsers")
        
        print("회원가입 완료! 저장된 사용자 목록:")
        for user in savedUsers {
            print("이메일: \(user["email"] ?? "")")
            print("이름: \(user["name"] ?? "")")
        }
        
        func showAlert(message: String) {
            let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "완료", style: .default))
            present(alert, animated: true)
        }
        
        // 회원가입 완료 후 로그인 화면으로 돌아가기
        dismiss(animated: true, completion: nil)
    }
}
