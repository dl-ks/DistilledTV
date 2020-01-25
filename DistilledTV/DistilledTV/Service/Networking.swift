import Foundation
import UIKit

// https://gist.github.com/ptseng/85f0aa8acbf48c0a64a68f4e44081a4d#file-networkingplayground-swift-L23

// MARK: HttpMethod
enum HttpMethod<Body> {
    case get
    case post(Body)
}

extension HttpMethod {
    var methodString: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
    
    func map<B>(f: (Body) -> B) -> HttpMethod<B> where B: Encodable {
        switch self {
        case .get: return .get
        case .post(let body): return .post(f(body))
        }
    }
}

// MARK: Error
enum LoadingError: Error {
    case networkUnavailable
    case timedOut
    case invalidStatusCode
}

// MARK: Resource
struct Resource<A> where A: Decodable {
    let method: HttpMethod<Data>
    let url: URL
    let parse: (Data) -> A? = { data in return try? JSONDecoder().decode(A.self, from: data) }
}

extension Resource {
    init<T>(method: HttpMethod<T>, url: URL) where T: Encodable {
        self.method = method.map { json in try! JSONEncoder().encode(json) }
        self.url = url
    }
}

// MARK: ImageResource
struct ImageResource {
    let url: URL
    let method: HttpMethod<Data>
    let parse: (Data) -> UIImage?
}

extension ImageResource {
    init(imageUrl: URL) {
        self.url = imageUrl
        self.method = .get
        self.parse = { data in return UIImage(data: data) }
    }
}

// MARK: Networking
extension URLRequest {
    init<A>(resource: Resource<A>) {
        self.init(url: resource.url)
        httpMethod = resource.method.methodString
        if case let .post(data) = resource.method { httpBody = data }
    }
    
    init(imageResource: ImageResource) {
        self.init(url: imageResource.url)
        httpMethod = imageResource.method.methodString
    }
}

final class Networking {
    func load<A: Codable>(resource: Resource<A>, responseHandler: @escaping (Result<A, LoadingError>) -> ()) {
        let request = URLRequest(resource: resource)
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                responseHandler(.failure(error as! LoadingError))
            }
            else if let data = data.flatMap(resource.parse) {
                responseHandler(.success(data))
            }
            
        }.resume()
    }
    
    func loadImage(resource: ImageResource, responseHandler: @escaping (Result<UIImage, LoadingError>) -> ()) {
        let request = URLRequest(imageResource: resource)
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                responseHandler(.failure(error as! LoadingError))
            }
            else if let data = data.flatMap(resource.parse) {
                responseHandler(.success(data))
            }
            
        }.resume()
    }
}

