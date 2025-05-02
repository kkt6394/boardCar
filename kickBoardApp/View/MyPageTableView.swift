//
//  MyPage.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/28/25.
//

import UIKit
import SnapKit

class MyPageTableView: UIView {
    weak var delegate: MyPageTableViewDeleagte?
    
    var user: User?
    
    let statusBar = UILabel()
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120))
    let logoutButton = UIButton()
    let deleteIdButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        statusBarSetup()
        setupTableView()
        setupConstraints()
        buttonSetup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    func statusBarSetup() {
        addSubview(statusBar)
        statusBar.text = "현재 상태 : 대여 중"
        statusBar.font = UIFont(name: "GmarketSansMedium", size: 18)
        statusBar.textAlignment = .center
        statusBar.textColor = .white
        statusBar.backgroundColor = .main
        statusBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
    func buttonSetup() {
        [logoutButton, deleteIdButton]
            .forEach { footerView.addSubview($0) }
        tableView.tableFooterView = footerView
        
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.setTitleColor(.black, for: .normal)
        logoutButton.titleLabel?.font = UIFont(name: "SUIT-Light", size: 14)
        logoutButton.backgroundColor = UIColor.font3
        logoutButton.layer.cornerRadius = 8.0
        logoutButton.clipsToBounds = true
        logoutButton.backgroundColor = .font3
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
//        deleteIdButton.setTitle("회원탈퇴", for: .normal)
//        deleteIdButton.setTitleColor(.black, for: .normal)
//        deleteIdButton.titleLabel?.font = UIFont(name: "SUIT-Light", size: 12)
//        deleteIdButton.backgroundColor = .white
        //        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        logoutButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(106)
            $0.height.equalTo(27)
        }
//        deleteIdButton.snp.makeConstraints {
//            $0.top.equalTo(logoutButton.snp.bottom).offset(12)
//            $0.trailing.equalToSuperview().offset(-20)
//            $0.width.equalTo(42)
//            $0.height.equalTo(15)
//        }
        
        
    }
    @objc func logoutButtonTapped() {
        delegate?.didTapLogoutButton()
    }
    //MARK: UI 설정 메서드
    private func setupTableView() {
        self.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
        addSubview(tableView)
        tableView.register(NameCell.self, forCellReuseIdentifier: NameCell.id)
        tableView.register(PointCell.self, forCellReuseIdentifier: PointCell.id)
        tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.id)
        tableView.register(ShareCell.self, forCellReuseIdentifier: ShareCell.id)
        tableView.register(AdCell.self, forCellReuseIdentifier: AdCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
    }
    //MARK: 제약 설정 메서드
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(statusBar.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50)
        }
    }
    
}

extension MyPageTableView: UITableViewDelegate, UITableViewDataSource {
    
    enum TableViewSections: Int, CaseIterable {
        case nameSection
        case pointSection
        case historySection
        case shareInfoSection
        case adSection
    }
    
    // 섹션 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewSections.allCases.count
    }
    // 섹션 안 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sectionType = TableViewSections(rawValue: section) else { return 0}
        switch sectionType {
        case .nameSection:
            return 1
        case .pointSection:
            return 1
        case .historySection:
            return 1
        case .shareInfoSection:
            return user?.shareKickBoard.count ?? 0
        case .adSection:
            return 1
        }
    }
    // 커스텀 헤더 뷰 내용
    func tableView(_ tableView: UITableView,viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let label: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "SUIT-Bold", size: 18)
            label.textColor = .black
            label.text = {
                switch TableViewSections(rawValue: section) {
                case .nameSection: return nil
                case .pointSection: return nil
                case .historySection: return "이용내역"
                case .shareInfoSection: return "내가 공유한 킥보드"
                case .adSection: return nil
                case .none: return nil
                }
            }()
            return label
        }()
        headerView.addSubview(label)
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
        }
        return label.text == nil ? nil : headerView
    }
    // 커스텀 헤더 뷰 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch TableViewSections(rawValue: section) {
        case .historySection, .shareInfoSection:
            return 25
        default:
            return 0
        }
    }
    
    // 셀 내용 (섹션 별 내용 분기)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = TableViewSections(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .nameSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NameCell.id, for: indexPath) as? NameCell else { return UITableViewCell() }
            if let user = self.user {
                cell.configure(with: user)
            }
            return cell
            
        case .pointSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PointCell.id, for: indexPath) as? PointCell else { return UITableViewCell() }
            if let user = self.user {
                cell.configure(with: user)
            }
            return cell
            
        case .historySection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.id, for: indexPath) as? HistoryCell else { return UITableViewCell() }
            if let user = self.user {
                cell.configure(with: user)
            }
            return cell
            
        case .shareInfoSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ShareCell.id, for: indexPath) as? ShareCell,
                  let user = self.user else { return UITableViewCell() }
            let kickBoard = user.shareKickBoard[indexPath.row]
            cell.configure(with: kickBoard)
            return cell
            
        case .adSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AdCell.id, for: indexPath) as? AdCell else { return UITableViewCell() }
            return cell
        }
    }
    func updateStatusBar() {
        // kickBoardHistory에서 대여 중인 킥보드가 있는지 확인
        guard
            let data = UserDefaults.standard.data(forKey: "kickBoardHistory"),
            let kickBoards = try? JSONDecoder().decode([KickBoard].self, from: data)
        else {
            print("킥보드 히스토리 정보를 가져오지 못했습니다.")
            DispatchQueue.main.async {
                self.statusBar.text = "현재 상태 : 대여 가능"
                self.statusBar.textColor = .main
                self.statusBar.backgroundColor = .sub3
            }
            return
        }
        
        if kickBoards.contains(where: { $0.isRent }) {
            // 대여 중인 킥보드가 있음
            DispatchQueue.main.async {
                self.statusBar.text = "현재 상태 : 대여 중"
                self.statusBar.textColor = .white
                self.statusBar.backgroundColor = .main
            }
        } else {
            // 대여 가능한 상태
            DispatchQueue.main.async {
                self.statusBar.text = "현재 상태 : 대여 가능"
                self.statusBar.textColor = .main
                self.statusBar.backgroundColor = .sub3
            }
        }
    }
    
}


