import UIKit
import Signals

class EditListInfoView : UIView {
    var info:AlistInfo!
    let onTap = Signal<AlistInfo>()
    let triggerInfoUpdate = Signal<AlistInfo>()
    let onDelete = Signal<Bool>()

    private var saveButton:UIButton = UIButton()
    private var titleField:UITextField = UITextField()

    private let buttonSaveText = "Click to update list"
    private let buttonEditText = "Edit List Info"

    init(frame: CGRect, info: AlistInfo) {
        super.init(frame : frame)
        self.info = info
        self.triggerInfoUpdate.subscribe(on: self, callback: self.updateInfo)

        saveButton.backgroundColor = UIColor.gray
        saveButton.setTitle(buttonEditText, for: UIControlState.normal)
        addSubview(saveButton)


        titleField.text = self.info.title
        titleField.backgroundColor = UIColor.lightGray
        titleField.textAlignment = NSTextAlignment.center
        addSubview(titleField)

        saveButton.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(self.snp.height).multipliedBy(0.1)
            make.top.equalTo(self).offset(20)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        saveButton.onTouchDown.subscribe(on: self) {
            self.onTap.fire(self.info)
        }

        titleField.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(saveButton.snp.bottom).offset(30)
            make.height.equalTo(self.snp.height).multipliedBy(0.2)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        titleField.onEditingDidEndOnExit.subscribe(on: self) {
            self.saveTitle(item: self.titleField.text!)
        }


        titleField.onTouchUpOutside.subscribe(on: self) {
            self.saveTitle(item: self.titleField.text!)
        }

        let deleteButton = UIButton()
        deleteButton.backgroundColor = UIColor.red
        deleteButton.setTitle("Delete List", for: UIControlState.normal)
        addSubview(deleteButton)

        deleteButton.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(self.snp.height).multipliedBy(0.1)
            make.bottom.equalTo(0).offset(-20)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        deleteButton.onTouchDown.subscribe(on: self) {
            self.onDelete.fire(true)
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
            saveButton.setTitle(buttonEditText, for: UIControlState.normal)
            return
        }
        self.info.title = cleaned
        titleField.text = cleaned
        saveButton.setTitle(buttonSaveText, for: UIControlState.normal)
    }

    func updateInfo(data: AlistInfo) {
        self.info = data
        titleField.text = self.info.title
    }
}
