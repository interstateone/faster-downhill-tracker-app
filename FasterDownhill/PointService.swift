import Foundation
import Alamofire
import Keys

final class PointService {

    // MARK: File Store

    private let queue = dispatch_queue_create("ca.brandonevans.fasterdownhill.tracker", DISPATCH_QUEUE_SERIAL)
    static private let fileURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!.URLByAppendingPathComponent("points")

    var points = [Point]()

    func loadPointsFromFile() {
        points = loadPoints()
    }

    func addPoint(point: Point) {
        points.append(point)
        savePoints(points)
    }

    func removeAllPoints() {
        points = []
        savePoints(points)
    }

    func savePointsToFile() {
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

    func uploadNewPointsToServer(completion: () -> Void) {
        let uploadGroup = dispatch_group_create()
        points.filter { $0.synced == false }.forEach { [weak self] point in
            dispatch_group_enter(uploadGroup)
            self?.uploadPoint(point) { point in
                point?.synced = true
                dispatch_group_leave(uploadGroup)
            }
        }
        
        dispatch_group_notify(uploadGroup, dispatch_get_main_queue()) { [weak self] in
            guard let _self = self else { return }
            _self.savePoints(_self.points)
            completion()
        }
    }

    func updateWithPointsFromServer(completion: () -> Void) {
        fetchAllPoints { [weak self] points in
            guard let _self = self, points = points else { return }
            let unsyncedPoints = _self.points.filter { $0.synced == false }
            self?.points = unsyncedPoints + points
            self?.savePointsToFile()
            completion()
        }
    }

    private let baseURLString = "https://tracker.brandonevans.ca"

    private func uploadPoint(point: Point, completion: (Point?) -> Void) {
        Alamofire.request(.POST, baseURLString + "/points", parameters: point.JSONRepresentation(), encoding: .JSON, headers: ["X-Auth-Token": FasterdownhillKeys().trackerToken()]).responseJSON { response in
            switch response.result {
            case .Success:
                completion(point)
            case .Failure(let error):
                NSLog("Error uploading point: %@", error)
                completion(nil)
            }
        }
    }
    
    private func fetchAllPoints(completion: ([Point]?) -> Void) {
        Alamofire.request(.GET, baseURLString + "/points", headers: ["X-Auth-Token": FasterdownhillKeys().trackerToken()]).responseJSON { response in
            switch response.result {
            case .Success(let json):
                guard let json = json as? [[String: AnyObject]] else {
                    completion(nil)
                    return
                }

                let points = json.map(Point.init).flatMap { $0 }
                completion(points)
            case .Failure(let error):
                NSLog("Error fetching all points: %@", error)
                completion(nil)
            }
        }
    }
}