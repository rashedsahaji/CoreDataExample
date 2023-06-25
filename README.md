
# Picsum App With Offline Support




## API Reference

#### Get all items

```http
  GET https://picsum.photos/v2/list
```


## API Callers

```swift
final class APIManager
```

Common class to help with api calls, it use ```EndPoint``` enum to get all the details about the url, query params and methods.

```swift
public typealias HTTPHeaders = [String: String]

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
}

protocol EndPoint {
    var path: String { get }
    var baseURL: String { get }
    var url: URL? { get }
    var method: HTTPMethods { get }
    var headers: HTTPHeaders? { get }
    var queryParams: [URLQueryItem]? { get }
}
```

Every API ENDPOINT should conform this ```EndPoint``` in order work with ```APIManager```


## Example REST Manger

Below mentoned code snippet from the project.

### EndPoint setup for getting image list
```swift
import Foundation
private struct PhotosConstants {
    static let list = "/v2/list";
}

enum PhotosEndPoint {
    case getListOfPhotos(page: Int, limit: Int)
}

extension PhotosEndPoint : EndPoint {
    var path: String {
        switch self {
        case .getListOfPhotos:
            return PhotosConstants.list
        }
    }
    
    var baseURL: String {
        KeysManager.URLs.apiBaseURL.value
    }
    
    var url: URL? {
        URL(string: "\(baseURL)\(path)")
    }
    
    var method: HTTPMethods {
        switch self {
        case .getListOfPhotos:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getListOfPhotos:
            return ["Content-Type": "application/json"]
        }
    }
    
    var queryParams: [URLQueryItem]? {
        switch self {
        case .getListOfPhotos(let page, let limit):
            return [URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "limit", value: "\(limit)")]
        }
    }
    
    
}
```

### Photos RESTManger

```swift
actor PhotosRestManager {
    private let pictureDB = CoreDataManager(modelName: "picturescache")
    //MARK: - For Getting Photos List with pagination
    public func getPhotosList(page: Int, limit: Int) async throws -> Photos? {
        do {
            let response = try await APIManager.shared.getData(from: PhotosEndPoint.getListOfPhotos(page: page, limit: limit))
            if (response.statusCode == 200) {
                let result = try JSONDecoder().decode(Photos.self, from: response.data)
                return result
            }
        } catch {
            throw CustomErrors.noInternet
        }
        return nil
    }
}
```

why ```actor``` when you are working with aync await there might be situation where you might have to access a variable from async methods, to avoid data racing actor help them to isolate them.

NOTE: Pagination is kept to 3 Pages only
