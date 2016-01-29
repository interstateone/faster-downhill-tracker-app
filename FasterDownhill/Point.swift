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

    // MARK: JSON

    static let JSONDateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }()

    func JSONRepresentation() -> [String: AnyObject] {
        let pointJSON: [String: AnyObject] = [
            "name": name,
            "inside": inside,
            "date": Point.JSONDateFormatter.stringFromDate(date),
            "longitude": coordinates.longitude,
            "latitude": coordinates.latitude
        ]
        return pointJSON
    }

    convenience init?(json: [String: AnyObject]) {
        if let name = json["name"] as? String,
               inside = json["inside"] as? Bool,
               dateString = json["date"] as? String,
               date = Point.JSONDateFormatter.dateFromString(dateString),
               coordinates = json["coordinates"] as? [Double],
               longitude = coordinates[safe: 0],
               latitude = coordinates[safe: 1] {
                self.init(name: name, inside: inside, date: date, coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                synced = true
                return
        }
        return nil
    }
}

func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.date == rhs.date
}
