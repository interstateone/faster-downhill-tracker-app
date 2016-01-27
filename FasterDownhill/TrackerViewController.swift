import UIKit
import MapKit

final class TrackerViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var proximitySegmentedControl: UISegmentedControl!
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var getNameButton: UIButton!
    @IBOutlet weak var locateButton: UIButton!
    @IBOutlet weak var trackPointButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Actions

    @IBAction func changeProximityType(sender: AnyObject) {
    }

    @IBAction func getCurrentLocation(sender: AnyObject) {
    }

    @IBAction func getNameOfCurrentLocation(sender: AnyObject) {
    }

    @IBAction func trackPoint(sender: AnyObject) {
    }
}

