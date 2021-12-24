//
//  NetworkLogger.swift
//  
//
//  Created by Orest Patlyka on 16.02.2021.
//

import Foundation

public protocol NetworkLogger {
    func log(request: URLRequest)
    func log(response: HTTPURLResponse, data: Data?, for request: URLRequest)
}

public final class DefaultNetworkLogger: NetworkLogger {
    public init() { }
    
    public func log(request: URLRequest) {
        startLogMessage()
        logRequestInfo(request)
        logHTTPBody(of: request)
    }
    
    public func log(response: HTTPURLResponse, data: Data?, for request: URLRequest) {
        startLogMessage()
        guard let requestURL = request.url else {
            return
        } 
        print("response for request: \(requestURL)")
        print("response status code: \(response.statusCode)")
        if let responseData = data?.prettyJson {
            print("response data: \(responseData)")
        }
    }
    
    private func startLogMessage() {
        print("--- [Network logger] ---")
    }
    
    private func logRequestInfo(_ request: URLRequest) {
        guard let requestURL = request.url,
              let headers = request.allHTTPHeaderFields,
              let method = request.httpMethod else {
            return
        }
        print("request: \(requestURL)")
        print("headers: \(headers)")
        print("method: \(method)")
    }
    
    private func logHTTPBody(of request: URLRequest) {
        guard let httpBody = request.httpBody,
              let body = httpBody.prettyJson else {
            return
        }
        print("body: \(body)")
    }
}

private extension Data {
    var prettyJson: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else { return nil }

        return prettyPrintedString
    }
}
