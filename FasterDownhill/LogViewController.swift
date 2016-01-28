import UIKit

protocol LogViewType: class {
    func updatePointViewModels(points: [PointViewModel])
}

final class LogViewController: UIViewController, LogViewType, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var presenter: LogPresenter?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.updatePoints()
    }

    // MARK: LogViewType

    private var pointViewModels = [PointViewModel]()
    func updatePointViewModels(viewModels: [PointViewModel]) {
        self.pointViewModels = viewModels
        tableView.reloadData()
    }

    // MARK: UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointViewModels.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(LogTableCell), forIndexPath: indexPath) as! LogTableCell
        let point = pointViewModels[indexPath.row]
        cell.textLabel?.text = point.name
        cell.detailTextLabel?.text = point.date
        return cell
    }
}

final class LogTableCell: UITableViewCell {
}

struct PointViewModel {
    let name: String
    let date: String
}