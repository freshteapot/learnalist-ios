import UIKit
import Signals

class EditListInfoViewController: UIViewController {
    let onSave = Signal<AlistInfo>()
    var info:AlistInfo!

    init(info: AlistInfo) {
        super.init(nibName: nil, bundle: nil)
        self.info = info
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        let addEditNavigationController = self.navigationController as? AddEditNavigationController

        view.backgroundColor = UIColor.white

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "List", style: .plain, target: addEditNavigationController, action: #selector (AddEditNavigationController.toList))

        let editView = EditListInfoView(frame: CGRect.zero, info:self.info)
        view.addSubview(editView)

        editView.snp.makeConstraints{(make) -> Void in
            make.top.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        editView.onTap.subscribe(on: self, callback: self.onEditSave)
    }

    func onEditSave(data: AlistInfo) {
        self.onSave.fire(data)
    }
}
