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
    /* 1...12범위의 숫자를 배열로 생성하고 map으로 새로운 배열로 리턴
     %02d format의 시작 % , 앞에 0을 넣고 시작, 2 두자리수, d 정수출력
     */
    let months = Array(1...12).map { String(format: "%02d", $0) }
    let days = Array(1...31).map { String(format: "%02d", $0) }
    let years = Array(2000...2030).map { "\($0)" }


    override func loadView() {
        view = shareView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        shareView.tableView.dataSource = self
        shareView.tableView.delegate = self
        shareView.tableView.register(ShareViewCell.self, forCellReuseIdentifier: "ShareViewCell")
        // 셀의 제약조건을 바탕으로 자동으로 계산
//        shareView.tableView.rowHeight = UITableView.automaticDimension
        // UITableView가 초기 렌더링시 성능 최적화 보통(100..300)으로 설정
//        shareView.tableView.estimatedRowHeight = 200
        shareView.tableView.isScrollEnabled = false
        shareView.tableView.separatorStyle = .none
        shareView.isUserInteractionEnabled = true
        shareView.tableView.isUserInteractionEnabled = true

//    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    
//    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//            view.addGestureRecognizer(tap)
        }

//
//    @objc func keyboardWillShow(_ notification: Notification) {
//            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//            shareView.tableView.contentInset.bottom = keyboardFrame.height
//        }
//    
//    @objc func keyboardWillHide(_ notification: Notification) {
//            shareView.tableView.contentInset.bottom = 0
//        }
//    
//    @objc func dismissKeyboard() {
//            view.endEditing(true)
//        }
//
//        deinit {
//            NotificationCenter.default.removeObserver(self)
//        }
}


    
//    @objc func buttonTapped() {
//        print("버튼이 눌렸습니다")
//        }

    
extension ShareViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShareViewCell", for: indexPath) as? ShareViewCell else {
                return UITableViewCell()
            }
            
            cell.pickerView.delegate = self
            cell.pickerView.dataSource = self
            cell.sharedButton.tag = indexPath.row
//            cell.sharedButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            
            
            return cell
        }
    }
                  
extension ShareViewController: UIPickerViewDelegate, UIPickerViewDataSource {
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 3
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch component {
            case 0: return years.count
            case 1: return months.count
            case 2: return days.count
            default: return 0
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return pickerView.frame.width / 3
        }
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = .black
            label.font = UIFont(name: "SUIT-Regular", size: 16)
            
            switch component {
            case 0: label.text = years[row] + "년"
            case 1: label.text = months[row] + "월"
            case 2: label.text = days[row] + "일"
            default: label.text = ""
            }
            
            label.backgroundColor = UIColor.white
            
            return label
        }
    }
                  
