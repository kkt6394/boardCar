//
//  LoginVC.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/25/25.
//

import UIKit

class LoginVC: UIViewController {

    let loginView = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func loadView() {
        // 뷰 컨트롤러 지정.
        loginView.loginVC = self
        self.view = loginView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

}

