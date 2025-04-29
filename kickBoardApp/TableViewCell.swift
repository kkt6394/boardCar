//
//  TableViewCell.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/28/25.
//

import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    
    static let id = "TableViewCell"

    enum TableViewSections {
        case nameSection(imageName: String, name: String, label: String)
        case pointSection(lable: String, imageName: String, point: Int)
        case historySection(header: String, first: Stirng, second: String)
        case 
        case fifth
    }
    private let helmetImage = UIImageView()
    private let safeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupCellConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupCell() {
        contentView.addSubview(helmetImage)
        contentView.addSubview(safeLabel)
        
        helmetImage.image = UIImage(named: "helmet")
        helmetImage.contentMode = .scaleAspectFit
        
        safeLabel.text = "최영건님,\n오늘도 안전 운전하세요!"
        safeLabel.numberOfLines = 2
    }
    private func setupCellConstraints() {
        helmetImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(4)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        safeLabel.snp.makeConstraints {
            $0.leading.equalTo(helmetImage.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
}
