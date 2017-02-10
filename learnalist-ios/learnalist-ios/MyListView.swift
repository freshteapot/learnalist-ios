import UIKit
import Signals

class MyListView: UIView, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView!
    var selectedIndexPath: IndexPath?
    var items = [AlistSummary]()
    let onTapOnTableRow = Signal<(uuid:String, listType:String)>()

    override init (frame : CGRect) {
        super.init(frame : frame)

        self.backgroundColor = UIColor.red

        tableView = UITableView(frame: frame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false

        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44;

        tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        tableView.estimatedSectionHeaderHeight = 30;

        tableView.sectionFooterHeight = UITableViewAutomaticDimension;
        tableView.estimatedSectionFooterHeight = 30;

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NameCell")
        addSubview(tableView)
        tableView.snp.makeConstraints{(make) -> Void in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell")! as UITableViewCell
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedIndexPath = indexPath
        // tableView.deselectRow(at: indexPath as IndexPath, animated: false)
        self.onTapOnTableRow.fire((uuid: items[indexPath.row].uuid, items[indexPath.row].listType))
    }

    func setItems(items: [AlistSummary]) {
        self.items = items
        tableView.reloadData()
    }
}
