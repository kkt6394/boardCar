//
//  DataModel.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/29/25.
//

import Foundation

struct UserProfile: Codable {
    var email: String
    var password: String
    var name: String
    var point: Int
    var kickBoardInfo: KickBoardProfile
}

struct KickBoardProfile: Codable {
    var name: String
    var rentPeriod: Date
    var coordinates: String
    
}
