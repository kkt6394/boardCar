//
//  DataModel.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/29/25.
//

import Foundation

struct User: Codable {
    var email: String
    var password: String
    var name: String
    var point: Int = 2000
    var count: Int = 0
    var shareKickBoard: [KickBoard] = []
}

struct KickBoard: Codable {
    var name: String = ""
    var year: String = ""
    var month: String = ""
    var day: String = ""
    var lat: Double
    var lon: Double
    var isRent: Bool = false
}
