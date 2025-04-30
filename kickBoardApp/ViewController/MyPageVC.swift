//
//  MyPageVC.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/28/25.
//

import UIKit

class MyPageVC: UIViewController {
    let myPageTableView = MyPageTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.view = myPageTableView

    }
    
}
