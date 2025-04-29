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
        view = loginView

    }

}

