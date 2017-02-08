import UIKit
import Signals

class V1EditListView: UIView, UITableViewDataSource, UITableViewDelegate {
    let onTitleAction = Signal<String>()
    let triggerListUpdate = Signal<AlistV1>()

    var aList:AlistV1!
    var tableView: UITableView!
    var titleButton: UIButton!

    init(frame: CGRect, aList: AlistV1) {
        super.init(frame : frame)
        self.aList = aList
        self.triggerListUpdate.subscribe(on: self, callback: self.updateList)

        let button = UIButton()
        button.backgroundColor = UIColor.gray
        button.setTitle("Save List", for: UIControlState.normal)

        addSubview(button)
        button.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(self.snp.height).multipliedBy(0.05)
            make.top.left.equalTo(self)
            make.right.equalTo(self)
        }

        titleButton = UIButton()
        titleButton.backgroundColor = UIColor.gray
        titleButton.contentHorizontalAlignment = .left

        addSubview(titleButton)
        titleButton.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(button.snp.bottom).offset(5)
            make.height.equalTo(self.snp.height).multipliedBy(0.1)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }

        titleButton.onTouchDown.subscribe(on: self) {
            self.onTitleAction.fire("open")
        }

        tableView = UITableView(frame: frame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false

        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44;
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NameCell")
        addSubview(tableView)

        tableView.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(titleButton.snp.bottom).offset(10)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }

        triggerListUpdate.fire(self.aList)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aList.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell")! as UITableViewCell
        cell.textLabel?.text = self.aList.data[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("do: Goto list view.")
        tableView.deselectRow(at: indexPath as IndexPath, animated: false)
    }

    func setItems(items: [String]) {
        self.aList.data = items
        tableView.reloadData()
    }

    func updateList(data: AlistV1) {
        self.aList = data
        let text = "title: \(self.aList.info.title)"
        titleButton.setTitle(text, for: UIControlState.normal)
        setItems(items: self.aList.data)
    }
}
