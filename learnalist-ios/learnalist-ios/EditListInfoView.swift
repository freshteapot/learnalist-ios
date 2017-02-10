import UIKit
import Signals

class EditListInfoView : UIView {
    var info:AlistInfo!
    let onTap = Signal<AlistInfo>()
    let triggerInfoUpdate = Signal<AlistInfo>()

    private var button:UIButton = UIButton()
    private var titleField:UITextField = UITextField()

    private let buttonSaveText = "Click to update list"
    private let buttonEditText = "Edit List Info"

    init(frame: CGRect, info: AlistInfo) {
        super.init(frame : frame)
        self.info = info
        self.triggerInfoUpdate.subscribe(on: self, callback: self.updateInfo)

        button = UIButton()
        button.backgroundColor = UIColor.gray
        button.setTitle(buttonEditText, for: UIControlState.normal)
        addSubview(button)


        titleField.text = self.info.title
        titleField.backgroundColor = UIColor.lightGray
        titleField.textAlignment = NSTextAlignment.center
        addSubview(titleField)

        button.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(self.snp.height).multipliedBy(0.1)
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }

        button.onTouchDown.subscribe(on: self) {
            self.onTap.fire(self.info)
        }

        titleField.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(button.snp.bottom).offset(30)
            make.height.equalTo(self.snp.height).multipliedBy(0.2)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }

        titleField.onEditingDidEndOnExit.subscribe(on: self) {
            self.saveTitle(item: self.titleField.text!)
        }


        titleField.onTouchUpOutside.subscribe(on: self) {
            self.saveTitle(item: self.titleField.text!)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }

    func saveTitle(item: String) {
        let cleaned = item.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleaned == "" {
            button.setTitle(buttonEditText, for: UIControlState.normal)
            return
        }
        self.info.title = cleaned
        button.setTitle(buttonSaveText, for: UIControlState.normal)
    }

    func updateInfo(data: AlistInfo) {
        self.info = data
        titleField.text = self.info.title
    }
}
