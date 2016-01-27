import UIKit
import CoreLocation
import MapKit

final class TrackerPresenter: NSObject, CLLocationManagerDelegate {
    private weak var view: TrackerView?
    private let locationManager = CLLocationManager()

    init(view: TrackerView) {
        self.view = view
        super.init()

        locationManager.delegate = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationMovedToBackground:"), name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationMovedToForeground:"), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func updateCurrentLocation() {
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
        else {
            locationManager.requestLocation()
        }
    }

    func updateNameOfCurrentLocation() {
        guard let location = location else {
            return
        }

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let placemarks = placemarks {
                let annotations = placemarks.filter { placemark in
                    return placemark.location != nil
                }.map { placemark -> MKAnnotation in
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = placemark.location!.coordinate
                    annotation.title = placemark.longDescription
                    return annotation
                }
                self?.view?.updateMapAnnotations(annotations)

                if let name = annotations.first?.title ?? "" {
                    self?.view?.updateLocationName(name)
                }
            }
            else if let error = error {
                NSLog("Error reverse geocoding current location: %@", error)
            }
        }
    }

    func trackPoint(name: String, inside: Bool) {
    }

    func applicationMovedToForeground(notification: NSNotification) {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func applicationMovedToBackground(notification: NSNotification) {
        locationManager.stopUpdatingLocation()
    }

    // MARK: CLLocationManagerDelegate

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        view?.updateHasLocationPermission(status == .AuthorizedWhenInUse)
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    private var location: CLLocation? = nil
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first!
        view?.updateMapCenterLocation(locations.first!)
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("%@", error)
    }
}

extension CLPlacemark {
    var longDescription: String {
        let strings = [name, locality, administrativeArea, country].flatMap { $0 }
        return strings.joinWithSeparator(", ")
    }
}
