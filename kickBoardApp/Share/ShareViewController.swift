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

        shareView.sharedButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

    // 데이터 생성 CRUD 중 C
    func createKickboardData() {
        let name = shareView.kickBoardName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !name.isEmpty else {
            showAlert(title: "입력 오류", message: "킥보드 이름을 작성하세요")
            return
        }
        // 피커뷰의 선택된 첫번째 행의 열 ex) 연도: component 0
        let yearIndex = shareView.pickerView.selectedRow(inComponent: 0)
        let monthIndex = shareView.pickerView.selectedRow(inComponent: 1)
        let dayIndex = shareView.pickerView.selectedRow(inComponent: 2)
        // 선택된 인덱스의 값 ex) let years = ["2000", "2001"..."2030"] years[0] 은 2000
        let selectedYear = years[yearIndex]
        let selectedMonth = months[monthIndex]
        let selectedDay = days[dayIndex]
       
        let newData = KickboardData(name: name, year: selectedYear, month: selectedMonth, day: selectedDay)
        
        let defaults = UserDefaults.standard
        var savedKickboardData: [KickboardData] = []
        
        if let savedData = defaults.data(forKey: "KickboardHistory"),
           let decoded = try? JSONDecoder().decode([KickboardData].self, from: savedData) {
            savedKickboardData = decoded
            if savedKickboardData.contains(where: { $0.name == name }) {
                showAlert(title: "중복 경고", message: "이미 등록된 킥보드 입니다")
                return
            }
        }
        
        savedKickboardData.append(newData)
        
        if let encoded = try? JSONEncoder().encode(savedKickboardData) {
            defaults.set(encoded, forKey: "KickboardHistory")
        }
        
    }
    
    func readKickboardData() {
        let defaults = UserDefaults.standard
        
        guard let savedData = defaults.data(forKey: "KickboardHistory"),
              let history = try? JSONDecoder().decode([KickboardData].self, from: savedData),
              let last = history.last else {
            print("저장된 킥보드 데이터가 없습니다.")
            return
        }
        
        print("\(history)")
        
        for (index, item) in history.enumerated() {
               print("[\(index + 1)] 이름: \(item.name), 날짜: \(item.year)-\(item.month)-\(item.day)")
           }
        
        }
    
    @objc func saveButtonTapped() {
        createKickboardData()
        readKickboardData()
        print("데이터 저장 완료")

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

