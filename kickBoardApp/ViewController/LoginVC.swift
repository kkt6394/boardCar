//
//  LoginVC.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/25/25.
//

import UIKit

class LoginVC: UIViewController, LoginViewDelegate {

    let loginView = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.delegate = self
//        UserDefaults.standard.removeObject(forKey: "savedUsers")



    }
    override func loadView() {
        // 뷰 컨트롤러 지정.
        loginView.loginVC = self
        self.view = loginView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    

}

