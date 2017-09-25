import Foundation
import CoreLocation

struct Place {
    let name: String
    let center: CLLocationCoordinate2D
    let northeast: CLLocationCoordinate2D
    let southwest: CLLocationCoordinate2D


    init?(json: [String: Any]) {
        guard let formatted = json["formatted"] as? String else {
            return nil
        }

        name = formatted

        guard let geometry = json["geometry"] as? [String: Double],
            let lat = geometry["lat"],
            let lng = geometry["lng"] else {
                return nil
        }

        center = CLLocationCoordinate2D(latitude: lat, longitude: lng)

        guard let bounds = json["bounds"] as? [String: Any] else {
            return nil
        }

        guard let northeastBounds = bounds["northeast"] as? [String: Double],
        let northeastLat = northeastBounds["lat"],
        let northeastLng = northeastBounds["lng"] else {
            return nil
        }

        northeast = CLLocationCoordinate2D(latitude: northeastLat, longitude: northeastLng)

        guard let southwestBounds = bounds["southwest"] as? [String: Double],
        let southwestLat = southwestBounds["lat"],
        let southwestLng = southwestBounds["lng"] else {
            return nil
        }

        southwest = CLLocationCoordinate2D(latitude: southwestLat, longitude: southwestLng)
    }
}
