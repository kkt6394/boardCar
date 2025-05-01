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
    
    let locationManager = CLLocationManager()
    
    override func loadView() {
        view = shareView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMyLocationButton()
        
        setLocation()
        
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
    
    @objc func myLocationButtonTapped() {

        // 상태 확인(위치 정보 제공에 동의했는지 등을 확인하는 부분)
        let status: CLAuthorizationStatus
        if #available(iOS 14.0, *) { // authorizationStatus 메서드는 iOS 14부터 생긴 것
            status = locationManager.authorizationStatus
        } else {   // 따라서 iOS 14 이하 버전은 CLLocationManager에 있던 메서드를 사용함
            status = CLLocationManager.authorizationStatus()
        }

        // 위치 정보 동의 상태가 항상 허용이거나 사용할 때 허용인 경우
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            // 현재 위치를 currentLocation에 담고
            if let currentLocation = locationManager.location {
                // 해당 위치로 카메라 이동
                moveCameraToCurrentLocation(currentLocation.coordinate)
            // 그렇지 않을 때는 다시 위치정보 요청
            } else {
                locationManager.requestLocation()
            }
            // 위치 정보 동의 상태가 사용할 때 한번만 허용인 경우
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func setLocation() {
        // CLLocationManager의 delegate 설정
        locationManager.delegate = self
        self.shareView.mapView.positionMode = .direction // 위치정보 모드(카메라 따라다니는거)
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func setupMyLocationButton() {
        let myBtn = self.shareView.currentButton
        myBtn.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
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

extension ShareViewController: CLLocationManagerDelegate {
    // MARK: 현위치로 업데이트 해주는 부분. 카메라도 해당 위치로 이동함
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        moveCameraToCurrentLocation(location.coordinate)
        print("위도: \(location.coordinate.latitude), 경도: \(location.coordinate.longitude)")
    }
    private func moveCameraToCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        DispatchQueue.main.async {
            let latLng = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
            let cameraUpdate = NMFCameraUpdate(scrollTo: latLng)
            cameraUpdate.animation = .easeIn
            self.shareView.mapView.moveCamera(cameraUpdate)
        }
    }
}

