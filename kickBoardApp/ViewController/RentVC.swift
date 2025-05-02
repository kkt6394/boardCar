//
//  RentVC.swift
//  kickBoardApp
//
//  Created by Lee on 4/28/25.
//
//
import Foundation
import UIKit
import NMapsMap

class RentVC: UIViewController {

    // 전체 킥보드 데이터
    private var markers: [NMFMarker] = []

    // 선택된 킥보드 데이터
    private var selectedMarker: NMFMarker?

    let locationManager = CLLocationManager()

    let rentView = RentView()

    override func loadView() {
        view = rentView
    }

    override func viewDidLoad() {
        self.rentView.delegate = self
        super.viewDidLoad()
        setLocation()
        setupMyLocationButton()
        setMarker()
        setupRentButton()
        setupReturnButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        // view가 로드 될때마다 마커를 지우고
        markers.forEach { $0.mapView = nil }
        markers.removeAll()
        // 다시 그리기
        loadMarker()
        setRentingMarker()
        selectedMarker = nil
    }

    private func setLocation() {
        // CLLocationManager의 delegate 설정
        locationManager.delegate = self
        self.rentView.myView.mapView.positionMode = .direction // 위치정보 모드(카메라 따라다니는거)
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: 현위치 버튼의 터치 이벤트 적용
    private func setupMyLocationButton() {
        let myBtn = self.rentView.currentLocationButton
        myBtn.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
    }

    // 현위치 버튼 선택 시 메서드
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

    func setMarker() {
        let markers = [
            // 4, 5번 View 킥보드 모델을 기준으로 데이터 추가
            KickBoard(name: "boardCar1", lat: 37.5560, lon: 126.9720),
            KickBoard(name: "boardCar2", lat: 37.5570, lon: 126.9700),
            KickBoard(name: "boardCar3", lat: 37.5550, lon: 126.9750),
            KickBoard(name: "boardCar4", lat: 37.5530, lon: 126.9686)
        ]

        self.markers = []  // 전체 킥보드 데이터 초기화
//        for mark in markers {
//            // 킥보드의 위치를 설정해줌
//            let marker = NMFMarker(position: NMGLatLng(lat: mark.lat, lng: mark.lon))
//            marker.iconImage = NMFOverlayImage(name: "kickBoardIcon")
//            marker.userInfo[MarkerUserInfo.kickBoardModel.rawValue] = mark
//            marker.touchHandler = markerTouchHandler
//            rentView.setMarker(marker)
//            self.markers.append(marker)
//        }

        do {
            let data = try JSONEncoder().encode(markers)
            UserDefaults.standard.set(data, forKey: "kickBoardHistory")
        } catch {
            print("킥보드 저장에 실패했습니다.")
        }
    }

    // MARK: UserDefaults의 데이터를 불러와서 load하는 메서드
    func loadMarker() {
        if let saveKickBoards = loadKickBoardsFromUserDefaults() {
            for mark in saveKickBoards {
                if mark.isRent == true {
                    continue
                }

                let marker = NMFMarker(position: NMGLatLng(lat: mark.lat, lng: mark.lon))
                marker.iconImage = NMFOverlayImage(name: "kickBoardIcon")
                marker.userInfo[MarkerUserInfo.kickBoardModel.rawValue] = mark
                marker.touchHandler = markerTouchHandler
                rentView.setMarker(marker)
                self.markers.append(marker)
            }
            print(saveKickBoards)

        }
    }

    // MARK: UserDefaults의 데이터 불러오는 메서드
    func loadKickBoardsFromUserDefaults() -> [KickBoard]? {
        guard let data = UserDefaults.standard.data(forKey: "kickBoardHistory") else { return nil }
        print(data)
        return try? JSONDecoder().decode([KickBoard].self, from: data)
    }

    // MARK: Mypage의 대여회수를 올려주는 메서드
    private func updateUserRentCount() {
        if let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail"),
           let savedUserData = UserDefaults.standard.data(forKey: "savedUsers"),
           var users = try? JSONDecoder().decode([User].self, from: savedUserData),
           let index = users.firstIndex(where: { $0.email == currentEmail }) {

            users[index].count += 1


            if let updatedUserData = try? JSONEncoder().encode(users) {
                UserDefaults.standard.set(updatedUserData, forKey: "savedUsers")
            }
        }
    }

    // MARK: 마커 이벤트 핸들링
    private lazy var markerTouchHandler: (NMFOverlay) -> Bool = { [weak self] overlay in
        guard let self = self, let tappedMarker = overlay as? NMFMarker else { return false }

        // 마커의 사용자 정보에서 KickBoard 모델 가져오기
        guard var model = tappedMarker.userInfo[MarkerUserInfo.kickBoardModel.rawValue] as? KickBoard else {
            return false
        }

        // 이미 다른 킥보드가 선택되어 있으면 경고를 띄운다
        if let currentSelected = self.selectedMarker, currentSelected != tappedMarker {
            self.showAlert("킥보드는 1대만 대여 가능합니다")
            return false
        }

        // 킥보드 대여 상태를 체크하고 해제하는 부분
        model.isRent = !model.isRent
        print(model.isRent)

        tappedMarker.userInfo[MarkerUserInfo.kickBoardModel.rawValue] = model

        // 마커의 아이콘 이미지를 대여 상태에 맞게 변경
        tappedMarker.iconImage = NMFOverlayImage(name: model.isRent ? "seletedKickBoard" : "kickBoardIcon")

        // 대여된 킥보드는 selectedMarker에 설정, 해제되면 nil로 설정
        self.selectedMarker = model.isRent ? tappedMarker : nil

        // 대여 버튼 보이기/숨기기
        self.rentView.rentButton.isHidden = !model.isRent

        return true
    }

    // MARK: 대여 버튼
    private func setupRentButton() {
        let rentBtn = self.rentView.rentButton
        rentBtn.addTarget(self, action: #selector(rentBtnTapped), for: .touchUpInside)
    }

    @objc func rentBtnTapped() {
        print("대여하기 버튼 클릭")
        self.rentView.rentButton.isHidden = true
        self.rentView.returnButton.isHidden = false

        if let marker = selectedMarker,
           var model = marker.userInfo[MarkerUserInfo.kickBoardModel.rawValue] as? KickBoard {

            model.isRent = true

            // Count + 1
            updateUserRentCount()

            // 모델을 다시 마커에 저장
            marker.userInfo[MarkerUserInfo.kickBoardModel.rawValue] = model
            marker.hidden = true

            if let data = try? JSONEncoder().encode(model) {
                UserDefaults.standard.set(data, forKey: "rentedKickBoard")
            }

            let updatedKickBoards = markers.compactMap { marker -> KickBoard? in
                guard var kickBoard = marker.userInfo[MarkerUserInfo.kickBoardModel.rawValue] as? KickBoard else {
                    return nil
                }

                if kickBoard.name == model.name {
                    kickBoard = model
                }

                return kickBoard
            }
            self.saveKickBoardsToUserDefaults(kickBoards: updatedKickBoards)

            print("저장 완료 후 디버깅용 출력")
            for board in updatedKickBoards {
                print("이름: \(board.name), 대여중: \(board.isRent)")
            }
        }
    }
    // MARK: 반납 버튼
    private func setupReturnButton() {
        let returnBtn = self.rentView.returnButton
        returnBtn.addTarget(self, action: #selector(returnBtnTapped), for: .touchUpInside)
    }

    @objc func returnBtnTapped() {
        print("반납하기 버튼 클릭")
        returnKickBoard()
    }

    // MARK: 대여한 마커를 처리하는 메서드
    private func setRentingMarker() {
        // 대여 중인 킥보드 데이터를 저장하고, seletedMarker에 담아주는 메서드
        if let data = UserDefaults.standard.data(forKey: "rentedKickBoard"),
           let rentedKickBoardData = try? JSONDecoder().decode(KickBoard.self, from: data) {

            let marker = NMFMarker(position: NMGLatLng(lat: rentedKickBoardData.lat, lng: rentedKickBoardData.lon))
            marker.iconImage = NMFOverlayImage(name: "selectedKicKBoard")
            marker.userInfo[MarkerUserInfo.kickBoardModel.rawValue] = rentedKickBoardData
            marker.touchHandler = markerTouchHandler
            self.selectedMarker = marker
        }
    }

    // MARK: 킥보드를 반납하는 메서드
    private func returnKickBoard() {
        // selectedMarker가 nil이 되면, rentedKickBoard에 저장한 대여 중인 킥보드를 불러옴
        if selectedMarker == nil {
            setRentingMarker()
        }

        // 대여 중 킥보드가 없으면, alert 표시
        guard let marker = selectedMarker,
              var model = marker.userInfo[MarkerUserInfo.kickBoardModel.rawValue] as? KickBoard,
              let location = locationManager.location else {
            showAlert("반납할 킥보드가 없습니다.")
            return
        }

        // 대여 중인 킥보드가 있으면 현재 위치로 위치 이동
        model.lat = location.coordinate.latitude
        model.lon = location.coordinate.longitude
        model.isRent = false

        // 현재 위치로 마커 업데이트
        marker.position = NMGLatLng(lat: model.lat, lng: model.lon)
        marker.hidden = false
        marker.iconImage = NMFOverlayImage(name: "kickBoardIcon")
        marker.userInfo[MarkerUserInfo.kickBoardModel.rawValue] = model

        // 마커를 지도에 setting
        rentView.setMarker(marker)

        // markers 배열(전체 킥보드 데이터) 업데이트
        if let index = markers.firstIndex(where: {
            let KickBoard = $0.userInfo[MarkerUserInfo.kickBoardModel.rawValue] as? KickBoard
            return KickBoard?.name == model.name
        }) {
            markers[index] = marker
        } else {
            markers.append(marker)
        }

        // 킥보드 전체 상태를 마커에 업데이트 및 UserDefaults에 저장
        let updatedKickBoards = markers.compactMap {
            $0.userInfo[MarkerUserInfo.kickBoardModel.rawValue] as? KickBoard
        }
        saveKickBoardsToUserDefaults(kickBoards: updatedKickBoards)

        // userDefaults에서 대여 기록 삭제
        UserDefaults.standard.removeObject(forKey: "rentedKickBoard")

        // UI 상태 초기화
        selectedMarker = nil
        rentView.returnButton.isHidden = true
        rentView.rentButton.isHidden = false
    }

    // MARK: UserDefault에 킥보드 저장하는 메서드
    func saveKickBoardsToUserDefaults(kickBoards: [KickBoard]) {
        do {
            let data = try JSONEncoder().encode(kickBoards)
            UserDefaults.standard.set(data, forKey: "kickBoardHistory")
        } catch {
            print("저장 실패: \(error)")
        }
    }
}

extension RentVC: RentViewDeleagte {
    func showAlert(_ text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인했어요", style: .default))
        present(alert, animated: true)
    }
}

// MARK: Location Manager 위치 관련 부분
extension RentVC: CLLocationManagerDelegate {
    // MARK: 현위치로 업데이트 해주는 부분. 카메라도 해당 위치로 이동함
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        moveCameraToCurrentLocation(location.coordinate)
        print("위도: \(location.coordinate.latitude), 경도: \(location.coordinate.longitude)")

    }

    // MARK: 위치 권한이 변경되었는지 확인하는 메서드
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("권한 설정됨")
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        case .notDetermined:
            print("권한 설정되지 않음")
        case .restricted, .denied:
            print("권한 요청 거부됨")
        default:
            print("권한에 대한 추적이 불가능합니다")
        }
    }

    // MARK: 위치 정보 요청에 실패했을 때 alert
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        self.showAlert("위치 정보를 가져오는데 실패했습니다. 설정을 확인해주세요")
        print("위치 정보를 가져오는데 실패했습니다: \(error.localizedDescription)")
    }

    // MARK: 현재 위치로 카메라를 이동하는 메서드
    private func moveCameraToCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        DispatchQueue.main.async {
            let latLng = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
            let cameraUpdate = NMFCameraUpdate(scrollTo: latLng)
            cameraUpdate.animation = .easeIn
            self.rentView.myView.mapView.moveCamera(cameraUpdate)
        }
    }
}
