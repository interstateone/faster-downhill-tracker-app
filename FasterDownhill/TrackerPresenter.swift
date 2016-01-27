import UIKit
import CoreLocation

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
