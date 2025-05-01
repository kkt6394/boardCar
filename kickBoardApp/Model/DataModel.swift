//
//  DataModel.swift
//  kickBoardApp
//
//  Created by 김기태 on 4/29/25.
//

import Foundation

//struct User: Codable {
//    let email: String
//    let password: String
//    let name: String
//}

struct User: Codable {
    var email: String
    var password: String
    var name: String
    var point: Int = 0
    var kickBoardInfo: KickBoard
}

struct KickBoard: Codable {
    var name: String = ""
    var rentPeriod: Date = Date()
    var lat: Double = 0.0
    var lon: Double = 0.0
    
}
