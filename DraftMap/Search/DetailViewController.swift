import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController {

    var place: Place?

    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = place?.name
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let place = place {
            centerMap(mapView, on: place)
        }
    }

    private func centerMap(_ map: MKMapView, on place: Place) {
        let nePoint = MKMapPointForCoordinate(place.northeast)
        let neRect = MKMapRect(origin: nePoint, size: MKMapSize(width: 0, height: 0))

        let swPoint = MKMapPointForCoordinate(place.southwest)
        let swRect = MKMapRect(origin: swPoint, size: MKMapSize(width: 0, height: 0))

        let mapRect = MKMapRectUnion(neRect, swRect)
        map.setVisibleMapRect(mapRect, animated: true)
    }
}
