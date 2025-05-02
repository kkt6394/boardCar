//
//  MyPageVC.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/28/25.
//

import UIKit

//
//  MyPageVC.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/28/25.
//

import UIKit

class MyPageVC: UIViewController, MyPageTableViewDeleagte {
    
    
    let myPageTableView = MyPageTableView()
    
    override func loadView() {
        self.view = myPageTableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        myPageTableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        if let user = loadCurrentUser() {
            myPageTableView.user = user
            myPageTableView.updateStatusBar()
            myPageTableView.tableView.reloadData()
        }
    }
    
    func loadCurrentUser() -> User? {
        guard let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail"),
              let data = UserDefaults.standard.data(forKey: "savedUsers"),
              let users = try? JSONDecoder().decode([User].self, from: data) else {
            return nil
        }
        return users.first(where: { $0.email == currentEmail })
    }
    func didTapLogoutButton() {
        let loginVC = LoginVC()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)

    }
    
}
