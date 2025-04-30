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
        
        shareView.pickerView.delegate = self
        shareView.pickerView.dataSource = self
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

