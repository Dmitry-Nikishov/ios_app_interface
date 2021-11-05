//
//  NetworkManager.swift
//  vk
//
//  Created by Дмитрий Никишов on 02.11.2021.
//

import Foundation

typealias RestDataHandler = (Data?) -> Void

enum AppConfiguration : CaseIterable {
    case people
    case starships
    case planets
    case todos
    
    var endpoint : ObjectResponseEndpoint<String> {
        switch self {
        case .people :
            return GetPeopleEndpoint()
        case .starships :
            return GetStarshipsEndpoint()
        case .planets :
            return GetPlanetsEndpoint()
        case .todos :
            return GetTodoEndpoint()
        }
    }
}

class MakeRequestUrlOperation : Operation {
    private var masterServerUrl : String
    private var path: String
    private var queryItems: [URLQueryItem]?
    private var resultUrl : URL?
    
    public var url : URL? {
        return resultUrl
    }
    
    init(masterServerUrl : String, path: String, queryItems: [URLQueryItem]?)
    {
        self.path = path
        self.queryItems = queryItems
        self.masterServerUrl = masterServerUrl
        
        super.init()
    }
    
    override func main()
    {
        guard let baseURL = URL(string: masterServerUrl) else {
            return
        }
             
        let requestURL: URL
        if path.isEmpty {
            requestURL = baseURL
        } else {
            requestURL = baseURL.appendingPathComponent(path)
        }
        
        if let queryItems = queryItems {
            var urlComponents = URLComponents(string: requestURL.absoluteString)
            urlComponents?.queryItems = queryItems
            guard let newRequestURL = urlComponents?.url else {
                return
            }
            
            self.resultUrl = newRequestURL
        } else {
            self.resultUrl = requestURL
        }
    }
}

class MakeBodyOperation : Operation {
    private var opResult : String?
    
    private var parameters : [String: Any]?
    
    public var body : String? {
        return opResult
    }
    
    init(_ parameters : [String: Any]?) {
        self.parameters = parameters
        super.init()
    }
    
    override func main()
    {
        if let params = self.parameters {
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            if let data = jsonData {
                opResult = String(data: data, encoding: .utf8)
            }
        }
    }
}

class MakeUrlSessionOperation : Operation {
    private var opResult : URLSession?
    private var timeout : TimeInterval?
    
    public var urlSession: URLSession? {
        return opResult
    }
    
    init(timeout : TimeInterval?)
    {
        super.init()
        self.timeout = timeout
    }
    
    override func main()
    {
        if let requestTimeout = self.timeout {
            let configuration = URLSessionConfiguration.default
            configuration.allowsCellularAccess = true
            configuration.waitsForConnectivity = true
            configuration.timeoutIntervalForRequest = requestTimeout
            configuration.httpMaximumConnectionsPerHost = 100
            configuration.urlCache = URLCache()
            opResult = URLSession(configuration: configuration)
        } else {
            opResult = URLSession.shared
        }
    }
}

class MakeRequestOperation : Operation
{
    private var resultOp : URLRequest?
    
    private var method: RequestType
    private var url: URL
    private var headers: [String: String]?
    private var body : String?
    
    public var urlRequest : URLRequest? {
        return resultOp
    }
    
    init( method: RequestType,
          url: URL,
          headers: [String: String]?,
          body: String? ) {
        self.method = method
        self.url = url
        self.headers = headers
        self.body = body
        super.init()
    }
    
    override func main()
    {
        var request = URLRequest(url: url) // уже содержит query items
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body?.data(using: String.Encoding.utf8)
        self.resultOp = request
    }
}

class RestDataGetter {
    init() {}
    
    public func execute(masterServerUrl : String,
                        executor : Executor,
                        endpoint : Endpoint,
                        handler : @escaping RestDataHandler)
    {
        let makeRequestUrlOp = MakeRequestUrlOperation(
            masterServerUrl : masterServerUrl,
            path : endpoint.path,
            queryItems : endpoint.queryItems)

        let makeBodyOp = MakeBodyOperation(endpoint.parameters)

        let makeSessionOp = MakeUrlSessionOperation(timeout : endpoint.timeout)

        executor.addOperations([makeRequestUrlOp,
                                makeBodyOp,
                                makeSessionOp])

        if let url = makeRequestUrlOp.url {
            let body = makeBodyOp.body
            let session = makeSessionOp.urlSession

            let makeRequestOperation = MakeRequestOperation(method: endpoint.method,
                                                            url: url,
                                                            headers: endpoint.httpHeaders,
                                                            body: body)
            executor.addOperations([makeRequestOperation])
            
            if let request = makeRequestOperation.urlRequest {
                session?.dataTask(with: request) { data, response, error in
//                    print("error.localizedDescription = \(String(describing: error?.localizedDescription))")

                    guard let httpResponse = response as? HTTPURLResponse else {
                        handler(nil)
                        return
                    }
                    
//                    print("response.allHeaderFields = \(httpResponse.allHeaderFields)")
//                    print("response.statusCode = \(httpResponse.statusCode)")
                                        
                    guard httpResponse.statusCode == 200 else {
                        handler(nil)
                        return
                    }
                                        
                    handler(data)
                }.resume()
            }
        }

    }
}

struct NetworkManager {
    private static let restDataGetter = RestDataGetter()

    static func execute( masterServerUrl : String,
                         endpointConfig : AppConfiguration,
                         dataHandler : @escaping RestDataHandler) {
        restDataGetter.execute( masterServerUrl : masterServerUrl,
                                executor: Executor.shared,
                                endpoint: endpointConfig.endpoint,
                                handler : dataHandler
        )
    }
}

