import CoreLocation

final class Point: NSObject, NSCoding {
    let name: String
    let inside: Bool
    let date: NSDate
    let coordinates: CLLocationCoordinate2D
    var synced: Bool = false

    init(name: String, inside: Bool, date: NSDate = NSDate(), coordinates: CLLocationCoordinate2D) {
        self.name = name
        self.inside = inside
        self.date = date
        self.coordinates = coordinates
    }

    // MARK: NSCoding

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeBool(inside, forKey: "inside")
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeDouble(coordinates.latitude, forKey: "latitude")
        aCoder.encodeDouble(coordinates.longitude, forKey: "longitude")
        aCoder.encodeBool(synced, forKey: "synced")
    }

    init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as? String ?? ""
        inside = aDecoder.decodeBoolForKey("inside")
        date = aDecoder.decodeObjectForKey("date") as? NSDate ?? NSDate()
        let latitude = aDecoder.decodeDoubleForKey("latitude")
        let longitude = aDecoder.decodeDoubleForKey("longitude")
        coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        synced = aDecoder.decodeBoolForKey("synced")
    }
}

func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.date == rhs.date
}