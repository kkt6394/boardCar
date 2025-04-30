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

    let rentView = RentView()

    let locationManager = CLLocationManager()
//    let geoCoder = CLGeocoder()

    override func loadView() {
        view = rentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocation()
        setupMyLocationButton()
    }

    private func setupMyLocationButton() {
        let myBtn = self.rentView.currentLocationButton
        myBtn.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
    }

    @objc func myLocationButtonTapped() {
        print("버튼 선택")
        let status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            print("사용 가능")
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    private func setLocation() {
        // CLLocationManager의 delegate 설정
        locationManager.delegate = self
//        locationManager.startUpdatingLocation()
        // 앱이 사용 중일 때 위치 접근 권한 요청
        // 이 메서드 호출 시 사용자에게 위치 권한 허용 여부를 묻는 알림이 표시됨
        self.rentView.myView.mapView.positionMode = .direction
        self.rentView.myView.showLocationButton = true
        locationManager.requestWhenInUseAuthorization()
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
        print("위치 정보를 가져오는데 실패합니다: \(error.localizedDescription)")
    }

    private func moveCameraToCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        DispatchQueue.main.async {
            let latLng = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
            let cameraUpdate = NMFCameraUpdate(scrollTo: latLng)
            cameraUpdate.animation = .easeIn
            self.rentView.myView.mapView.moveCamera(cameraUpdate)
        }
        //        let latLng = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        //        let cameraUpdate = NMFCameraUpdate(scrollTo: latLng)
        //        cameraUpdate.animation = .easeIn
        //        self.rentView.myView.mapView.moveCamera(cameraUpdate)
        //    }
    }
}
