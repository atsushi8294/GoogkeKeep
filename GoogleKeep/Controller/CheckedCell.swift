//
//  CheckedCell.swift
//  GoogleKeep
//
//  Created by 石橋惇 on 2020/11/18.
//

import UIKit

class CheckedCell: UITableViewCell {
    
    @IBOutlet weak var cellLbl: UITextView!
    @IBOutlet weak var lblHeight: NSLayoutConstraint!
    @IBOutlet weak var delBtn: UIButton!
    
    let tvTag = 1
    var delegate: OperationCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellLbl.delegate = self
        cellLbl.autocorrectionType = .no
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteCell(_ sender: Any) {
        delegate?.removeItem(tvTag: tvTag, tag: self.tag)
    }
    
    @IBAction func checkCell(_ sender: Any) {
        delegate?.check(tvTag: tvTag, cellTag: self.tag)
    }
    
}



extension CheckedCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.saveData(text: textView.text, tvTag: tvTag, tag: self.tag)
        delegate?.reloadTVConstant()
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
        if text == "\n" {
            print("\n改行が押されてセルの挿入")
            delegate?.insertItem(tvTag: tvTag, tag: self.tag + 1)
            return false
        } else if text == "" && self.tag != 0 && textView.text! == "" {
            delegate?.removeItem(tvTag: tvTag, tag: self.tag)
            delegate?.focusCell(tvTag: tvTag, cellTag: self.tag - 1)
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.hideDelBtn(tvTag: tvTag, tag: self.tag)
    }
}
