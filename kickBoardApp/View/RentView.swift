//
//  RentView.swift
//  kickBoardApp
//
//  Created by Lee on 4/28/25.
//

import Foundation
import UIKit
import NMapsMap
import CoreLocation

enum ViewMode {
    case rentMode
    case returnMode
}

class RentView: UIView {

    let myView = NMFNaverMapView()

    private let networkService = NetworkService()

    private lazy var addressTextField: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.text = "주소를 입력해주세요(동까지만 입력)"
        textView.textColor = .font3
        textView.backgroundColor = .sub3
        textView.returnKeyType = .done
        textView.textContainer.maximumNumberOfLines = 1
        textView.font = UIFont(name: "SUIT-Medium", size: 16)
        textView.textContainerInset = UIEdgeInsets(top: 3, left: 0, bottom: 2, right: 0)
        return textView
    }()

    private lazy var boardImage: UIImageView = {
        let myImage = UIImageView(image: UIImage(named: "icon"))
        return myImage
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .sub3
        stackView.layer.cornerRadius = 9

        [boardImage, addressTextField].forEach {
            stackView.addSubview($0)
        }
        return stackView
    }()

    private lazy var rentButton: UIButton = {
        let button = UIButton()
        button.setTitle("대여하기", for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Bold", size: 20)
        button.backgroundColor = .main
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(rentBtnTapped), for: .touchUpInside)
        return button
    }()

    lazy var currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "newCurrentLocationBtn"), for: .normal)
        button.layer.shadowColor = UIColor.font2.cgColor
        button.layer.cornerRadius = 23
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        button.layer.shadowRadius = 2
        //        button.addTarget(self, action: #selector(locationBtnTapped), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configureStackView()
        configureUI()
        setMarker()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        configureStackView()
        configureUI()
        setMarker()
    }

    private func setupView() {
        addSubview(myView)

        myView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func configureStackView() {
        boardImage.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.top).offset(2)
            $0.bottom.equalTo(stackView.snp.bottom).offset(-2)
            $0.leading.equalTo(stackView.snp.leading).offset(15)
            $0.trailing.equalTo(addressTextField.snp.leading).offset(-23)
        }

        addressTextField.snp.makeConstraints {
            $0.trailing.equalTo(stackView.snp.trailing).inset(13)
            $0.leading.equalTo(stackView.snp.leading).inset(76)
            $0.top.equalTo(stackView.snp.top).inset(8)
            $0.bottom.equalTo(stackView.snp.bottom).inset(8)
        }
    }

    private func configureUI() {
        [stackView, rentButton, currentLocationButton].forEach {
            addSubview($0)
        }

        rentButton.isHidden = true

        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(21)
            $0.trailing.equalToSuperview().offset(-21)
            $0.height.equalTo(44)
        }

        rentButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-114)
            $0.leading.equalToSuperview().offset(120)
            $0.trailing.equalToSuperview().offset(-120)
        }

        currentLocationButton.snp.makeConstraints {
            $0.width.height.equalTo(46)
            $0.trailing.equalToSuperview().offset(-25)
            $0.bottom.equalToSuperview().offset(-113)
        }
    }

    private func setMarker() {
        let markers: [NMFMarker] = [
            NMFMarker(position: NMGLatLng(lat: 37.5557, lng: 126.9708)),
            NMFMarker(position: NMGLatLng(lat: 37.5560, lng: 126.9720)),
            NMFMarker(position: NMGLatLng(lat: 37.5570, lng: 126.9700))
        ]

        // 네이버에서 제공하는 Overlay 핸들러(네이버 지도 마커의 터치 이벤트를 처리하는 클로저)
        let handler: (NMFOverlay) -> Bool = { [weak self] overlay in
            guard let marker = overlay as? NMFMarker else { return false }

            let isSelected = marker.userInfo["selected"] as? Bool ?? false
            if isSelected {
                marker.iconImage = NMFOverlayImage(name: "kickBoard")
                marker.userInfo["selected"] = false
            } else {
                marker.iconImage = NMFOverlayImage(name: "seletedKickBoard")
                marker.userInfo["selected"] = true
                self?.rentButton.isHidden = false
            }

            return true
        }

        for marker in markers {
            marker.mapView = myView.mapView
            marker.iconImage = NMFOverlayImage(name: "kickBoard")
            marker.userInfo["selected"] = false
            marker.touchHandler = handler
        }
    }

    @objc
    private func rentBtnTapped() {
        print("대여하기 버튼이 눌렸습니다")
    }

//    @objc
//    private func locationBtnTapped() {
//        print("현 위치 버튼이 눌렸습니다")
//    }
}

extension RentView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard addressTextField.textColor == .font3 else { return }
        addressTextField.text = nil
        addressTextField.textColor = .font1
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if addressTextField.text == "" {
            addressTextField.text = "주소를 입력해주세요(동까지만 입력)"
            addressTextField.textColor = .font3
        }
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            searchAddress(address: textView.text)
            return false
        }
        return true
    }

    private func searchAddress(address: String) {
        networkService.fetchDataByAlamofire(address: address) { result in
            switch result {
            case .success(let (x, y)):
                DispatchQueue.main.async {
                    self.moveToCamera(lat: y, lng: x)
                }
            case .failure(let error):
                guard let error = error as? CustomError else {
                    print(error)
                    return
                }
                print(error)
            }
        }
    }

    private func moveToCamera(lat: String, lng: String) {
        guard let userlat = Double(lat) else { return }
        guard let userlng = Double(lng) else { return }
        let coord = NMGLatLng(lat: userlat, lng: userlng)
        self.myView.mapView.zoomLevel = 16
        self.myView.mapView.moveCamera(NMFCameraUpdate(scrollTo: coord))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}

extension RentView: NMFMapViewTouchDelegate {

}
