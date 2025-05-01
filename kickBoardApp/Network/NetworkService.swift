//
//  NetworkService.swift
//  kickBoardApp
//
//  Created by Lee on 4/29/25.
//

import Foundation
import Alamofire

class NetworkService {

    private let clientId = Secret.naverMapApiKey
    private let clientSecret = Secret.naverClientSecret

    func fetchDataByAlamofire(address: String, completion: @escaping (Result<(String, String), Error>) -> Void) {
        let scheme = "https"
        let host = "maps.apigw.ntruss.com"
        // "maps.apigw.ntruss.com"
        let path = "/map-geocode/v2/geocode"
        let listQueryItem = URLQueryItem(name: "query", value: "\(address)")

        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [listQueryItem]

        guard let url = components.url else {
            completion(.failure(CustomError.wrongURL))
            return
        }

        let headers: HTTPHeaders = [
            "X-NCP-APIGW-API-KEY-ID": clientId,
            "X-NCP-APIGW-API-KEY": clientSecret,
            "Accept": "application/json"
        ]

        AF.request(url, headers: headers).responseDecodable(of: NaverMapData.self) { response in
            switch response.result {
            case .success(let data):
                if let address = data.addresses.first {
                    let x = address.x
                    let y = address.y
                    print("경도: \(x) , 위도: \(y)")
                    completion(.success((x, y)))
                } else {
                    completion(.failure(CustomError.wrongAdress))
                }
            case .failure(let error):
                // 실패했을 경우, 서버 오류에 따른 적절한 처리
                if let afError = error.asAFError {
                    switch afError {
                    case .responseValidationFailed:
                        completion(.failure(CustomError.failRequest))
                    default:
                        completion(.failure(CustomError.wrongAdress))
                    }
                } else {
                    completion(.failure(CustomError.failRequest))
                }
            }
        }
    }
}
