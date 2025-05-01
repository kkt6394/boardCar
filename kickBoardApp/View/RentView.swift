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

protocol RentViewDeleagte {
    func showAlert(_ text: String)
}

class RentView: UIView {

    var delegate: RentViewDeleagte?

    var selectedMarker = NMFMarker?.self

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

    lazy var rentButton: UIButton = {
        let button = UIButton()
        button.setTitle("대여하기", for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Bold", size: 20)
        button.backgroundColor = .main
        button.layer.cornerRadius = 15
        return button
    }()

    lazy var returnButton: UIButton = {
        let button = UIButton()
        button.setTitle("반납하기", for: .normal)
        button.setTitleColor(.main, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Bold", size: 20)
        button.backgroundColor = .sub3
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.main.cgColor
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
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configureStackView()
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        configureStackView()
        configureUI()
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
        [stackView, rentButton, returnButton, currentLocationButton].forEach {
            addSubview($0)
        }

        rentButton.isHidden = true
        returnButton.isHidden = true

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

        returnButton.snp.makeConstraints {
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

    // MARK: View에 마커 세팅
    // 세부 마커 설정은 VC에 두었습니다
    func setMarker(_ marker: NMFMarker) {
        marker.mapView = myView.mapView
    }
}

// MARK: textView 세부 설정
extension RentView: UITextViewDelegate {
    // textView가 입력 중일 때 폰트 색상 변경하는 메서드
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard addressTextField.textColor == .font3 else { return }
        addressTextField.text = nil
        addressTextField.textColor = .font1
    }

    // textView가 비어 있을 때 placeHolder 같이 적용한 메서드
    func textViewDidEndEditing(_ textView: UITextView) {
        if addressTextField.text == "" {
            addressTextField.text = "주소를 입력해주세요(동까지만 입력)"
            addressTextField.textColor = .font3
        }
    }

    // textView에서 return 키를 누르면 textView.text를 전달하도록 한 메서드
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            searchAddress(address: textView.text)
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    // MARK: 서치 바에서 주소 검색하는 메서드
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

                DispatchQueue.main.async {
                    self.delegate?.showAlert(error.errorTitle)
                }

                print(error)
            }
        }
    }

    // 카메라의 시점을 이동하게끔 하는 메서드
    private func moveToCamera(lat: String, lng: String) {
        guard let userlat = Double(lat) else { return }
        guard let userlng = Double(lng) else { return }
        let coord = NMGLatLng(lat: userlat, lng: userlng)
        self.myView.mapView.zoomLevel = 16
        self.myView.mapView.moveCamera(NMFCameraUpdate(scrollTo: coord))
    }

    // UI에 터치 이벤트가 발생하면 입력을 종료하게 하는 메서드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}

/*
 RentView에서 주소 입력을 잘못하면 Alert이 필요한 상황
 View는 Alert을 present 할수 없음
 그러면 VC에서 해야하는데
 View 입장에서는 대리자가 필요함
 */
