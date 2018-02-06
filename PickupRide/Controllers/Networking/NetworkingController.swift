//
//  NetworkingController.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 06/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum TaskResult {
    case success
    case error
}

class NetworkingController {
    
    private let session: URLSession
    private let disposeBag = DisposeBag()

    private var url: URL {
        return URL(string: "http://localhost:3000/jsons")!
    }
    
    init(session: URLSession) {
        self.session = session
    }
    
    func send(booking: Booking) {
        let apiData = BookingAPIData(from: booking)
        send(object: apiData)
    }
    
    func send(action: RideAction) {
        let apiData = RideActionAPIData(from: action)
        send(object: apiData)
    }
    
    func send(gpsData: GPSData) {
        let apiData = GPSAPIData(from: gpsData)
        send(object: apiData)
    }
    
    private func send<T: Encodable>(object: T) {
        guard let jsonData = encode(object: object) else { return }
        let request = createPostRequest(to: url, with: jsonData)
        session.rx.response(request: request).subscribe().disposed(by: disposeBag)
    }
    
    private func encode<T: Encodable>(object: T) -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try? encoder.encode(object)
        return jsonData
    }
    
    private func createPostRequest(to url: URL, with data: Data) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = data
        return urlRequest
    }
}
