//
//  Endpoint.swift
//  vk
//
//  Created by Дмитрий Никишов on 02.11.2021.
//

import Foundation

public enum RequestType: String {
    case put = "PUT"
    case get = "GET"
    case post = "POST"
}

public class Endpoint {
    public var method: RequestType { fatalError() }
    public var path: String { fatalError() }
    public var httpHeaders: [String: String] {
        switch method {
        case .get:
            return ["Cache-Control": "no-cache"]
            
        case .post, .put:
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
                    "Cache-Control": "no-cache"]
        }
    }

    public var parameters: [String: Any]?
    public var timeout: TimeInterval?
    public var queryItems: [URLQueryItem]?
    
    public init() {}
}

public class ObjectResponseEndpoint<T: Decodable>: Endpoint { }

public final class GetPeopleEndpoint: ObjectResponseEndpoint<String> {
    
    override public var method: RequestType { return .get }
    override public var path: String { "/api/people/8" }
    
    override public init() {
        super.init()
    }
}

public final class GetStarshipsEndpoint: ObjectResponseEndpoint<String> {
    
    override public var method: RequestType { return .get }
    override public var path: String { "/api/starships/3" }
    
    override public init() {
        super.init()
    }
}

public final class GetPlanetsEndpoint: ObjectResponseEndpoint<String> {
    
    override public var method: RequestType { return .get }
    override public var path: String { "/api/planets/5" }
    
    override public init() {
        super.init()
    }
}

