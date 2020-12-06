//
//  TodoCell.swift
//  GoogleKeep
//
//  Created by 石橋惇 on 2020/11/16.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var todoCellLbl: UITextView!
//    @IBOutlet weak var lblHeight: NSLayoutConstraint!
    @IBOutlet weak var delBtn: UIButton!
    
    var delegate: OperationCellDelegate!
    let tvTag = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        
        todoCellLbl.delegate = self
        todoCellLbl.autocorrectionType = .no
//        lblHeight.constant = 200
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func deleteCell(_ sender: Any) {
        delegate?.removeItem(tvTag: tvTag, tag: self.tag)
    }
    
    @IBAction func checkCell(_ sender: Any) {
        delegate?.check(tvTag: self.tvTag, cellTag: self.tag)
    }
    
}





extension TodoCell: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        delegate?.saveData(text: textView.text, tvTag: tvTag, tag: self.tag)
        delegate?.resizeCellLbl(tvTag: tvTag, tag: self.tag, height: 0)
    }

    // 文字が入力されるたびに呼ばれる
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if text == "\n" {
            delegate?.insertItem(text: "", tvTag: tvTag, tag: self.tag + 1)
            return false
        } else if text == "" && self.tag != 0 && textView.text! == "" {
            delegate?.removeItem(tvTag: tvTag, tag: self.tag)
            delegate?.focusCell(tvTag: tvTag, cellTag: self.tag - 1)
        }
        return true
    }


    // 編集開始すると呼ばれる
    func textViewDidBeginEditing(_ textView: UITextView) {
//        print("\n編集開始")
        delegate?.hideDelBtn(tvTag: tvTag, tag: self.tag)
    }

}
