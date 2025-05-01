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
    let years = Array(2025...2030).map { "\($0)" }
    
    override func loadView() {
        view = shareView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareView.mapView.addCameraDelegate(delegate: self)
        
        shareView.pickerView.delegate = self
        shareView.pickerView.dataSource = self

        shareView.sharedButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        // UserDefault에 들어있는 데이터 삭제 기능
        // UserDefaults.standard.removeObject(forKey: "KickboardHistory")

    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

    // 데이터 생성 CRUD 중 C
    func createKickboardData() {
        let name = shareView.kickBoardName.text ?? ""
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
        
        let center = shareView.mapView.cameraPosition.target
       
        let newData = KickBoard(name: name, year: selectedYear, month: selectedMonth, day: selectedDay, lat: center.lat, lon: center.lng)
        
        let defaults = UserDefaults.standard
        
        var savedKickboardData: [KickBoard] = []
        
        if let savedData = defaults.data(forKey: "kickBoardHistory"),
           let decoded = try? JSONDecoder().decode([KickBoard].self, from: savedData) {
            savedKickboardData = decoded
            if savedKickboardData.contains(where: { $0.name == name }) {
                showAlert(title: "중복 경고", message: "이미 등록된 킥보드 입니다")
                return
            }
        }
        
        savedKickboardData.append(newData)
        
        if let encoded = try? JSONEncoder().encode(savedKickboardData) {
            defaults.set(encoded, forKey: "kickBoardHistory")
        }
        
        if let currentEmail = defaults.string(forKey: "currentUserEmail"),
           let savedUserData = defaults.data(forKey: "savedUsers"),
           var users = try? JSONDecoder().decode([User].self, from: savedUserData),
           let index = users.firstIndex(where: { $0.email == currentEmail }) {
            
            users[index].shareKickBoard.append(newData)
            
            if let updatedUserData = try? JSONEncoder().encode(users) {
                defaults.set(updatedUserData, forKey: "savedUsers")
        }
            
    }
            
}
    
    func readKickboardData() {
        let defaults = UserDefaults.standard
        
        guard let savedData = defaults.data(forKey: "kickBoardHistory"),
              let history = try? JSONDecoder().decode([KickBoard].self, from: savedData) else {
            print("저장된 킥보드 데이터가 없습니다.")
            return
        }
        
        print("\(history)")
        
        for (index, item) in history.enumerated() {
               print("[\(index + 1)] 이름: \(item.name), 날짜: \(item.year)-\(item.month)-\(item.day), x좌표:\(item.lat), y좌표:\(item.lon)")
           }
        
        }
    
    func addKickboardIconAtCenter() {
        let center = shareView.mapView.cameraPosition.target

        let marker = NMFMarker()
        marker.position = center
        marker.iconImage = NMFOverlayImage(name: "kickBoardIcon")
        marker.width = 42
        marker.height = 42
        marker.mapView = shareView.mapView
    }
    
    @objc func saveButtonTapped() {
        createKickboardData()
        readKickboardData()
        addKickboardIconAtCenter()
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

extension ShareViewController: NMFMapViewCameraDelegate {
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        print(mapView.cameraPosition.target)
    }
}

// kickBoardHistory 에 킥보드정보를 업로드해주고, 이 업로드 된 정보를 savedusers에 올려준다

/*
 키값 kickBoardHistory, savedUsers, currentUserEmail
 저장된 

 import Foundation

 struct User: Codable {
     var email: String
     var password: String
     var name: String
     var point: Int = 2000
     var count: Int = 0
     var shareKickBoard: [KickBoard] = []
 }

 struct KickBoard: Codable {
     var name: String = ""
     var year: String = ""
     var month: String = ""
     var day: String = ""
     var lat: Double
     var lon: Double
     var isRent: Bool = false
 }
 */
