//
//  SplashView.swift
//  kickBoardApp
//
//  Created by 최영건 on 4/28/25.
//

import UIKit
import SnapKit

class SplashView: UIViewController {
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "BoardCar")
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
    }
}

extension SplashView {
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(logoImage)
    }
    
    private func setLayout() {
        logoImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
    }
}
