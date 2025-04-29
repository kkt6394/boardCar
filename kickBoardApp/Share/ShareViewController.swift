//
//  ShareViewController.swift
//  kickBoardApp
//
//  Created by 김재우 on 4/28/25.
//

import UIKit
import NMapsMap
import SnapKit

class ShareViewController: UIViewController {
    
    let shareView = ShareView()
    let option = ["Option 1", "Option 2", "Option 3"]


    override func loadView() {
        view = shareView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let myView = NMFNaverMapView(frame: view.frame)
//                view.addSubview(myView)
        
        shareView.tableView.dataSource = self
        shareView.tableView.delegate = self
        shareView.tableView.register(ShareViewCell.self, forCellReuseIdentifier: "ShareViewCell")
        // 셀의 제약조건을 바탕으로 자동으로 계산
        shareView.tableView.rowHeight = UITableView.automaticDimension
        // UITableView가 초기 렌더링시 성능 최적화 보통(100..300)으로 설정
        shareView.tableView.estimatedRowHeight = 200
        shareView.tableView.isScrollEnabled = false
        shareView.tableView.separatorStyle = .none
        shareView.tableView.backgroundColor = .white


        }
    
    @objc func buttonTapped() {
            
        }
}
    
extension ShareViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShareViewCell", for: indexPath) as? ShareViewCell else {
            return UITableViewCell()
        }

        cell.pickerView.delegate = self
        cell.pickerView.dataSource = self
        cell.sharedButton.tag = indexPath.row
        cell.sharedButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)


        return cell
    }
}

extension ShareViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        option.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        option[row]
    }
}

