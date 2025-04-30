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
    // 킥보드 데이터
    private var selectedMarker: NMFMarker?

    let locationManager = CLLocationManager()

    let rentView = RentView()

    override func loadView() {
        view = rentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocation()
        setupMyLocationButton()
        setMarker()
        setupRentButton()
        setupReturnButton()
    }

    private func setLocation() {
        // CLLocationManager의 delegate 설정
        locationManager.delegate = self
        self.rentView.myView.mapView.positionMode = .direction // 위치정보 모드(카메라 따라다니는거)
        locationManager.requestWhenInUseAuthorization()
    }

    // 현위치 버튼의 터치 이벤트 적용
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
                // 해당 좌표로 카메라 이동
                moveCameraToCurrentLocation(currentLocation.coordinate)
            // 그렇지 않을 때는 다시 위치정보 요청
            } else {
                locationManager.requestLocation()
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    // Marker(킥보드)를 만드는 메서드
    func setMarker() {
        let coordinates = [
            NMGLatLng(lat: 37.5557, lng: 126.9708),
            NMGLatLng(lat: 37.5560, lng: 126.9720),
            NMGLatLng(lat: 37.5570, lng: 126.9700),
            NMGLatLng(lat: 37.5550, lng: 126.9750),
            NMGLatLng(lat: 37.5530, lng: 126.9686)
        ]

        // 좌표를 하나씩 순회하면서
        for coord in coordinates {
            // 킥보드의 위치를 설정해줌
            let marker = NMFMarker(position: coord)
            marker.iconImage = NMFOverlayImage(name: "kickBoard")
            marker.userInfo[MarkerUserInfo.selected.rawValue] = false
            marker.touchHandler = markerTouchHandler
            rentView.setMarker(marker)
        }
    }

    // 마커에 유저 인터렉션 있을 때 이벤트 핸들링하는 핸들러
    private lazy var markerTouchHandler: (NMFOverlay) -> Bool = { [weak self] overlay in
        // weak self니까 self가 있는지 확인. tappedMarker를 NMFMarker로 다운 캐스팅
        guard let self = self, let tappedMarker = overlay as? NMFMarker else { return false }

        // 선택된 마커가 있는지 확인하고, 기존에 선택된 마커와 다른 경우에만 아래의 설정 적용
        if let selected = self.selectedMarker, selected != tappedMarker {
            selected.iconImage = NMFOverlayImage(name: "kickBoard")
            selected.userInfo[MarkerUserInfo.selected.rawValue] = false
        }

        // 선택 상태 토글
        let isSelected = tappedMarker.userInfo[MarkerUserInfo.selected.rawValue] as? Bool ?? false
        if isSelected {
            tappedMarker.iconImage = NMFOverlayImage(name: "kickBoard")
            tappedMarker.userInfo[MarkerUserInfo.selected.rawValue] = false
            self.selectedMarker = nil
            self.rentView.rentButton.isHidden = true
        } else {
            tappedMarker.iconImage = NMFOverlayImage(name: "seletedKickBoard")
            tappedMarker.userInfo[MarkerUserInfo.selected.rawValue] = true
            self.selectedMarker = tappedMarker
            self.rentView.rentButton.isHidden = false
        }

        return true
    }

    private func setupRentButton() {
        let rentBtn = self.rentView.rentButton
        rentBtn.addTarget(self, action: #selector(rentBtnTapped), for: .touchUpInside)
    }

    @objc func rentBtnTapped() {
        print("대여하기 버튼 클릭")
        self.rentView.rentButton.isHidden = true
        selectedMarker?.hidden = true
        self.rentView.returnButton.isHidden = false
    }

    private func setupReturnButton() {
        let returnBtn = self.rentView.returnButton
        returnBtn.addTarget(self, action: #selector(returnBtnTapped), for: .touchUpInside)
    }

    @objc func returnBtnTapped() {
        print("반납하기 버튼 클릭")
        self.rentView.returnButton.isHidden = true
        selectedMarker?.hidden = false
        selectedMarker?.userInfo[MarkerUserInfo.selected.rawValue] = false
        selectedMarker?.iconImage = NMFOverlayImage(name: "kickBoard")
    }
}

extension RentVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocation 호출")
        guard let location = locations.last else { return }
        moveCameraToCurrentLocation(location.coordinate)
        print("위도: \(location.coordinate.latitude), 경도: \(location.coordinate.longitude)")

    }

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
            print("알 수 없는 권한 상태")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("위치 정보를 가져오는데 실패했습니다: \(error.localizedDescription)")
    }

    private func moveCameraToCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        DispatchQueue.main.async {
            let latLng = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
            let cameraUpdate = NMFCameraUpdate(scrollTo: latLng)
            cameraUpdate.animation = .easeIn
            self.rentView.myView.mapView.moveCamera(cameraUpdate)
        }
    }
}
