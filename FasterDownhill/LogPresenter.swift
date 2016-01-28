import Foundation

final class LogPresenter {
    private weak var view: LogViewType?
    private let service: PointService
    private let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter
    }()

    init(view: LogViewType, service: PointService) {
        self.view = view
        self.service = service
    }

    func updatePoints() {
        view?.updatePointViewModels(service.points.map { PointViewModel(name: $0.name, date: dateFormatter.stringFromDate($0.date)) })
    }
}