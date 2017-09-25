import Foundation

class SearchApi {

    let apiKey = "1b1128be13c348398054f09f3aeaffd5"
    let baseURL = "https://api.opencagedata.com/geocode/v1/json"

    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var errorMsg = ""
    typealias SearchResult = ([Place]?, String?) -> Void

    func reverseGeocode(place: String, completion: @escaping SearchResult) {
        dataTask?.cancel()

        guard var urlComponents = URLComponents(string: baseURL) else {
            return
        }

        urlComponents.query = "q=\(place)&key=\(apiKey)"

        guard let url = urlComponents.url else {
            return
        }

        dataTask = defaultSession.dataTask(with: url) {[weak self] data, response, error in
            defer { self?.dataTask = nil }

            if let error = error {
                self?.errorMsg += "Network error: \(error.localizedDescription)\n"
            } else {
                guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    return
                }

                let results = self?.parseResponse(data)

                DispatchQueue.main.async {
                    completion(results, self?.errorMsg)
                }
            }
        }

        dataTask?.resume()
    }

    private func parseResponse(_ data: Data) -> [Place]? {
        var response: [String: Any]?

        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch let err as NSError {
            errorMsg += "Parse error: \(err.localizedDescription)\n"
            return nil
        }

        guard let resp = response, let results = resp["results"] as? [Any] else {
            errorMsg += "Parse error: results not found\n"
            return nil
        }

        var places = [Place]()
        for result in results {
            if let placeResult = result as? [String: Any],
                let place = Place(json: placeResult) {
                places.append(place)
            }
        }

        return places
    }
}
