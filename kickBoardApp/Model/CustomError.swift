//
//  CustomError.swift
//  kickBoardApp
//
//  Created by Lee on 4/29/25.
//

import Foundation

enum CustomError: Error {
    case wrongURL
    case failRequest
    case failDecoding
    case failEncoding

    var errorTitle: String {
        switch self {
        case .wrongURL:
            return "잘못된 URL입니다"
        case .failRequest:
            return "잘못된 요청입니다"
        case .failDecoding:
            return "JSON 디코딩 실패"
        case .failEncoding:
            return "JSON 인코딩 실패"
        }
    }
}
