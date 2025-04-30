//
//  TabViewVC.swift
//  kickBoardApp
//
//  Created by Lee on 4/28/25.
//

import Foundation
import UIKit

class UnderTabBarController: UITabBarController {
    let firstVC = RentVC()
    let secondVC = ViewController()
    let thirdVC = LoginVC()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        configureBarItems()
        configureTabBar()
    }

    private func configureBarItems() {
        firstVC.tabBarItem = UITabBarItem(title: "홈", image: .noneSelectHomeIcon, selectedImage: UIImage(named: "selectedHomeIcon"))
        secondVC.tabBarItem = UITabBarItem(title: "등록", image: .noneSelectBoardIcon, selectedImage: UIImage(named: "selectedBoardIcon"))
        thirdVC.tabBarItem = UITabBarItem(title: "마이페이지", image: .noneSelectMyPageIcon, selectedImage: UIImage(named: "selectedMyPageIcon"))

        [firstVC, secondVC, thirdVC].forEach {
            $0.tabBarItem.imageInsets = UIEdgeInsets(top: -5, left: 10, bottom: -10, right: 10)
            $0.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 3, vertical: 12)
        }

        viewControllers = [firstVC, secondVC, thirdVC]
    }

    private func configureTabBar() {

        let appearance = UITabBarAppearance()

        tabBar.tintColor = .main
        tabBar.backgroundColor = .white

        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .font: UIFont(name: "SUIT-Regular", size: 12) ?? .systemFont(ofSize: 12),
            .foregroundColor: UIColor.gray
        ]

        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .font: UIFont(name: "SUIT-ExtraBold", size: 12) ?? .systemFont(ofSize: 12),
            .foregroundColor: UIColor.main
        ]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
