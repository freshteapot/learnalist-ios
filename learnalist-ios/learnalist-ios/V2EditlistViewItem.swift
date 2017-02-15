
import UIKit
import Signals

class V2EditListViewItem : UIView {

    let onSave = Signal<AlistV2Row>()
    let onDelete = Signal<Bool>()

    private var enableDismissKeyboard = false

    private var itemFieldFrom:UITextField!
    private var itemFieldTo:UITextField!
    private var saveButton:UIButton = UIButton()

    private let buttonSaveText = "Click to save to list"
    private let buttonEditText = "Add or Edit item"

    init(frame: CGRect, rowData: AlistV2Row) {
        super.init(frame : frame)

        saveButton = UIButton()
        saveButton.backgroundColor = UIColor.gray
        saveButton.setTitle(buttonEditText, for: UIControlState.normal)

        addSubview(saveButton)

        let deleteButton = UIButton()
        deleteButton.backgroundColor = UIColor.red
        deleteButton.setTitle("Delete Row", for: UIControlState.normal)

        if rowData.from.isEmpty && rowData.to.isEmpty {
            deleteButton.isHidden = true
        }

        deleteButton.onTouchDown.subscribe(on: self) {
            self.onDelete.fire(true)
        }
        addSubview(deleteButton)


        deleteButton.snp.makeConstraints{(make) -> Void in
            make.bottom.equalTo(0).offset(-20)
            make.height.equalTo(self.snp.height).multipliedBy(0.1)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        itemFieldFrom = UITextField()
        itemFieldFrom.backgroundColor = UIColor.lightGray
        itemFieldFrom.textAlignment = NSTextAlignment.center
        itemFieldFrom.text = rowData.from
        addSubview(itemFieldFrom)

        itemFieldTo = UITextField()
        itemFieldTo.backgroundColor = UIColor.lightGray
        itemFieldTo.textAlignment = NSTextAlignment.center
        itemFieldTo.text = rowData.to
        addSubview(itemFieldTo)

        saveButton.snp.makeConstraints{(make) -> Void in
            make.height.equalTo(self.snp.height).multipliedBy(0.1)
            // We set the offset to match the other controllers here as we want to capture the 20 at the top.
            make.top.equalTo(self).offset(20)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        saveButton.onTouchDown.subscribe(on: self) {
            if self.enableDismissKeyboard {
                return
            }

            let from = self.itemFieldFrom.text!
            let to = self.itemFieldTo.text!
            if !from.isEmpty && !to.isEmpty {
                self.onSave.fire(AlistV2Row(from: from, to: to))
            }
        }

        itemFieldFrom.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(saveButton.snp.bottom).offset(30)
            make.height.equalTo(self.snp.height).multipliedBy(0.2)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        itemFieldTo.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(itemFieldFrom.snp.bottom).offset(20)
            make.height.equalTo(self.snp.height).multipliedBy(0.2)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        itemFieldFrom.onEditingDidBegin.subscribe(on: self) {
            self.enableDismissKeyboard = true
        }

        itemFieldFrom.onEditingDidEndOnExit.subscribe(on: self) {
            self.save()
        }

        itemFieldFrom.onTouchUpOutside.subscribe(on: self) {
            self.save()
        }

        itemFieldTo.onEditingDidBegin.subscribe(on: self) {
            self.enableDismissKeyboard = true
        }

        itemFieldTo.onEditingDidEndOnExit.subscribe(on: self) {
            self.save()
        }

        itemFieldTo.onTouchUpOutside.subscribe(on: self) {
            self.save()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.enableDismissKeyboard {
            self.endEditing(true)
            self.save()
        }
    }

    func save() {
        self.enableDismissKeyboard = false
        let cleanedFrom = itemFieldFrom.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        itemFieldFrom.text = cleanedFrom

        let cleanedTo = itemFieldTo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        itemFieldTo.text = cleanedTo

        if !itemFieldFrom.text!.isEmpty && !itemFieldTo.text!.isEmpty {
            saveButton.setTitle(buttonSaveText, for: UIControlState.normal)
            return
        }
        saveButton.setTitle(buttonEditText, for: UIControlState.normal)
    }
}
