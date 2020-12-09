//
//  TodoData.swift
//  GoogleKeep
//
//  Created by 石橋惇 on 2020/11/17.
//

import UIKit

class TodoData {
    
    var title: String!
    var tag: Int!
    var isDone: Bool!
    var height: CGFloat = 0
    
    
    /// 初期化
    init(title: String, tag: Int, isDone: Bool = false) {
        self.title = title
        self.tag = tag
        self.isDone = isDone
    }
    
    
    /// ステートメントを変更する（チェックされたかを変更する）
    func setState(state: Bool) {
        self.isDone = state
    }
    
    
    /// タグを変更する
    func setTag(tag: Int) {
        self.tag = tag
    }
    
    
    func setHeight(height: CGFloat) {
        self.height = height
    }
}
