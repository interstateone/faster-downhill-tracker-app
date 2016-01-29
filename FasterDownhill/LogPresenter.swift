import Foundation
import FormatterKit

final class LogPresenter {
    private weak var view: LogViewType?
    private let service: PointService
    private let timeIntervalFormatter = TTTTimeIntervalFormatter()

    init(view: LogViewType, service: PointService) {
        self.view = view
        self.service = service
    }

    func updatePoints() {
        let now = NSDate()
        let viewModels = service.points.sort { $0.date.compare($1.date) == .OrderedDescending }.map { point -> PointViewModel in
            let name = point.inside ? "In \(point.name)" : "Near \(point.name)"
            let date = timeIntervalFormatter.stringForTimeInterval(point.date.timeIntervalSinceDate(now))
            return PointViewModel(name: name, date: date, synced: point.synced)
        }
        view?.updatePointViewModels(viewModels)
    }
    
    func syncPoints() {
        service.uploadNewPointsToServer { [weak self] in
            self?.service.updateWithPointsFromServer {
                self?.updatePoints()
                self?.view?.endRefreshing()
            }
        }
    }
}