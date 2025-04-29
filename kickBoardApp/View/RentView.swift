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

    private let myView = NMFNaverMapView()

    private lazy var addressTextField: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.text = "주소를 입력해주세요(동까지만 입력)"
        textView.textColor = .font3
        textView.backgroundColor = .sub3
        textView.font = UIFont(name: "SUIT-Medium", size: 18)
        textView.textContainerInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
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

    private lazy var currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "newCurrentLocationBtn"), for: .normal)
        button.layer.shadowColor = UIColor.font2.cgColor
        button.layer.cornerRadius = 23
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        button.layer.shadowRadius = 2
        button.addTarget(self, action: #selector(locationBtnTapped), for: .touchUpInside)
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
        [stackView, rentButton, currentLocationButton].forEach {
            addSubview($0)
        }

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

    @objc
    private func rentBtnTapped() {
        print("대여하기 버튼이 눌렸습니다")
    }

    @objc
    private func locationBtnTapped() {
        print("현 위치 버튼이 눌렸습니다")
    }
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
}

