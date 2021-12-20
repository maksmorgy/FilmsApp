//
//  RequestEncoder.swift
//  
//
//  Created by Orest Patlyka on 22.02.2021.
//

import Foundation

public protocol RequestEncoder {
    func encode<T: Encodable>(_ model: T) throws -> Data
}

public struct URLRequestEncoder: RequestEncoder {
        
    private let encoder: JSONEncoder = .init()
    
    public init() {}
    
    public func encode<T>(_ model: T) throws -> Data where T : Encodable {
        let json = try? JSONSerialization.jsonObject(
            with: encoder.encode(model)
        )
        let dictionary = json as? [String: String]
        var urlComponents = URLComponents()
        urlComponents.queryItems = dictionary?.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        if let data = urlComponents.query?.data(using: .utf8) {
            return data
        } else {
            throw EncodingError.invalidValue(model, .init(
                codingPath: [],
                debugDescription: "Error occured when trying to encode model using URL encoded format",
                underlyingError: nil)
            )
        }
    }
}

public struct DefaultRequestEncoder: RequestEncoder {
    public init() { }
    
    private let encoder: JSONEncoder = .init()
    
    public func encode<T>(_ model: T) throws -> Data where T: Encodable {
        encoder.outputFormatting = .sortedKeys
        return try encoder.encode(model)
    }
}

public struct SnakeCaseRequestEncoder: RequestEncoder {
    public init() { }
    
    private let encoder: JSONEncoder = .makeSnakeCaseEncoder()
    
    public func encode<T>(_ model: T) throws -> Data where T: Encodable {
        return try encoder.encode(model)
    }
}
