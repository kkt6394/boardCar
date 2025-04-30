//
//  MyPage.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/28/25.
//

import UIKit
import SnapKit

class MyPageTableView: UIView {
    
    let statusBar = UITextView()
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        statusBarSetup()
        setupTableView()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    func statusBarSetup() {
        addSubview(statusBar)
        statusBar.text = "현재 상태 : 대여 중"
        statusBar.textColor = .white
        statusBar.backgroundColor = .main
        statusBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
    //MARK: UI 설정 메서드
    private func setupTableView() {
        addSubview(tableView)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 20

    }
    //MARK: 제약 설정 메서드
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(statusBar.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
}

extension MyPageTableView: UITableViewDelegate, UITableViewDataSource {
    
    
    // 섹션 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewCell.TableViewSections.allCases.count
    }
    // 섹션 안 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = TableViewCell.TableViewSections(rawValue: section) else { return 0}
        switch sectionType {
        case .nameSection:
            return 1
        case .pointSection:
            return 1
        case .historySection:
            return 2
        case .shareInfoSection:
            return 2
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
                switch TableViewCell.TableViewSections(rawValue: section) {
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
        switch TableViewCell.TableViewSections(rawValue: section) {
        case .historySection, .shareInfoSection:
            return 25
        default:
            return 0
        }
    }

    
    // 셀 내용 (섹션 별 내용 분기)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let section = TableViewCell.TableViewSections(rawValue: indexPath.section)
        switch section {
        case .nameSection:
            cell.configure(type: .name)
        case .pointSection:
            cell.configure(type: .point)
        case .historySection:
            if indexPath.row == 0 {
                cell.configure(type: .historyBorrow)
            } else {
                cell.configure(type: .historyShare)
            }
        case .shareInfoSection:
            cell.configure(type: .shareInfo)
        case .adSection:
            cell.configure(type: .ad)
        case .none:
            return UITableViewCell()
        }
        
        return cell
        
    }
}
