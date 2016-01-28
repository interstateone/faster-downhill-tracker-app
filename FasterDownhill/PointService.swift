import Foundation
import Alamofire

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

    func syncPoints(completion: () -> Void) {
        let uploadGroup = dispatch_group_create()
        points.filter { $0.synced == false }.forEach { [weak self] point in
            dispatch_group_enter(uploadGroup)
            self?.uploadPoint(point) { point in
                point.synced = true
                dispatch_group_leave(uploadGroup)
            }
        }
        
        dispatch_group_notify(uploadGroup, dispatch_get_main_queue()) { [weak self] in
            guard let _self = self else { return }
            _self.savePoints(_self.points)
            completion()
        }
    }

    private func uploadPoint(point: Point, success: (Point) -> Void) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_main_queue()) {
            success(point)
        }
//        Alamofire.request(.POST, "http://").responseJSON { response in
//            switch response.result {
//            case .Success: success(point)
//            case .Failure(let error): NSLog("Error uploading point: %@", error)
//            }
//        }
    }
}