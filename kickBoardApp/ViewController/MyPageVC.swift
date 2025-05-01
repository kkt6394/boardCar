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

class MyPageVC: UIViewController {
    let myPageTableView = MyPageTableView()
    
    override func loadView() {
        self.view = myPageTableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let user = loadCurrentUser() {
            myPageTableView.user = user
            myPageTableView.tableView.reloadData()
            myPageTableView.updateStatusBar()
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
}
