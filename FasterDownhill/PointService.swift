import Foundation

final class PointService {

    // MARK: File Store

    private let queue = dispatch_queue_create("ca.brandonevans.fasterdownhill.tracker", DISPATCH_QUEUE_SERIAL)
    static private let fileURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!.URLByAppendingPathComponent("points")

    var points = [Point]()

    func loadPoints() {
        points = loadPoints()
    }

    func addPoint(point: Point) {
        points.append(point)
        savePoints(points)
    }

    private func savePoints(points: [Point]) {
        dispatch_async(queue) {
            let data = NSKeyedArchiver.archivedDataWithRootObject(points)
            let success = data.writeToURL(PointService.fileURL, atomically: true)
            if !success {
                NSLog("Failed to write points to file.")
            }
        }
    }

    private func loadPoints() -> [Point] {
        guard let data = NSData(contentsOfURL: PointService.fileURL),
                  points = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Point] else {
            return []
        }
        return points
    }

    // MARK: Point Submission
}