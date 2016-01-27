import UIKit
import MapKit

protocol TrackerView: class {
    func updateLocationName(name: String)
    func updateMapCenterLocation(location: CLLocation)
    func updateHasLocationPermission(hasPermission: Bool)
    func updateMapAnnotations(annotations: [MKAnnotation])
}

final class TrackerViewController: UIViewController, TrackerView {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var proximitySegmentedControl: UISegmentedControl!
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var getNameButton: UIButton!
    @IBOutlet weak var locateButton: UIButton!
    @IBOutlet weak var trackPointButton: UIButton!

    var presenter: TrackerPresenter? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: TrackerView

    func updateLocationName(name: String) {
        locationNameTextField.text = name
    }

    func updateMapCenterLocation(location: CLLocation) {
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(location.coordinate, abs(location.horizontalAccuracy), abs(location.verticalAccuracy)), animated: true)
    }

    func updateHasLocationPermission(hasPermission: Bool) {
        mapView.showsUserLocation = hasPermission
    }

    func updateMapAnnotations(annotations: [MKAnnotation]) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }

    // MARK: Actions

    private var inside = true
    @IBAction func changeProximityType(sender: AnyObject) {
        inside = proximitySegmentedControl.selectedSegmentIndex == 0
    }

    @IBAction func getCurrentLocation(sender: AnyObject) {
        presenter?.updateCurrentLocation()
    }

    @IBAction func getNameOfCurrentLocation(sender: AnyObject) {
        presenter?.updateNameOfCurrentLocation()
    }

    @IBAction func trackPoint(sender: AnyObject) {
        presenter?.trackPoint(locationNameTextField.text ?? "", inside: inside)
    }
}