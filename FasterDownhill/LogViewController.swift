import UIKit

protocol LogViewType: class {
    func updatePointViewModels(points: [PointViewModel])
    func endRefreshing()
}

final class LogViewController: UITableViewController, LogViewType {
    var presenter: LogPresenter?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.updatePoints()
    }

    @IBAction func syncNow(sender: AnyObject) {
        presenter?.syncPoints()
    }

    // MARK: LogViewType

    private var pointViewModels = [PointViewModel]()
    func updatePointViewModels(viewModels: [PointViewModel]) {
        self.pointViewModels = viewModels
        tableView.reloadData()
    }

    func endRefreshing() {
        refreshControl?.endRefreshing()
    }

    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointViewModels.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(LogTableCell), forIndexPath: indexPath) as! LogTableCell
        let point = pointViewModels[indexPath.row]
        cell.textLabel?.text = point.name
        cell.detailTextLabel?.text = point.date
        cell.accessoryType = point.synced ? .Checkmark : .None
        return cell
    }
}

final class LogTableCell: UITableViewCell {
}

struct PointViewModel {
    let name: String
    let date: String
    let synced: Bool
}