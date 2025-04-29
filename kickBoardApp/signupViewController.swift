//
//  signUpViewController.swift
//  kickBoardApp
//
//  Created by 최영건 on 4/28/25.
//

import UIKit
import SnapKit

class signupViewController: UIViewController {
    
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
        signupButton.addTarget(self, action: #selector(signup), for: .touchUpInside)
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
        
        // 회원가입 완료 후 로그인 화면으로 돌아가기
        dismiss(animated: true, completion: nil)
    }

    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "완료", style: .default))
        present(alert, animated: true)
    }
}
