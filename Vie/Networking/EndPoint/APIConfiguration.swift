import Alamofire
protocol APIConfiguration {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    func getURL() throws -> URLRequest
}

