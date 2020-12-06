//
//  CustomTextView.swift
//  GoogleKeep
//
//  Created by 石橋惇 on 2020/11/19.
//

import UIKit

class CustomTextView: UITextView, UITextViewDelegate {
    
//    override func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
////        super.
//        return true
//    }
    
//    override func textViewDidChange(_ textView: UITextView) {
////        super.
//    }
    
    override func shouldChangeText(in range: UITextRange, replacementText text: String) -> Bool {
        print("textView range: \(range)")
        super.shouldChangeText(in: range, replacementText: text)
        return true
    }
    
    
}
