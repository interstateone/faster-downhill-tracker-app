import CoreLocation

final class Point: Equatable {
    let name: String
    let inside: Bool
    let date: NSDate
    let coordinates: CLLocationCoordinate2D

    init(name: String, inside: Bool, date: NSDate = NSDate(), coordinates: CLLocationCoordinate2D) {
        self.name = name
        self.inside = inside
        self.date = date
        self.coordinates = coordinates
    }
}

func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.date == rhs.date
}