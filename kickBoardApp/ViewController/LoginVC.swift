//
//  LoginVC.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/25/25.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    override func loadView() {
        let loginView = LoginView()
        loginView.loginVC = self
        self.view = loginView

    }

}

