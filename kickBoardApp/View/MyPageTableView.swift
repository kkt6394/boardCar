//
//  MyPage.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/28/25.
//

import UIKit
import SnapKit

class MyPageTableView: UIView {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
        setupConstraints()
        
    }
    //MARK: UI 설정 메서드
    private func setupTableView() {
        addSubview(tableView)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        tableView.dataSource = self
        tableView.delegate = self

    }
    //MARK: 제약 설정 메서드
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

extension MyPageTableView: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        TableViewCell.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewCell.items[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TableViewCell.sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = TableViewCell.items[indexPath.section][indexPath.row]
        cell.backgroundColor = .white
        
        return cell
        
    }
}
