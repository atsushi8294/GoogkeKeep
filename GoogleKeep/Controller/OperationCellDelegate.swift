//
//  OperationCellDelegate.swift
//  GoogleKeep
//
//  Created by 石橋惇 on 2020/11/19.
//


import UIKit

protocol OperationCellDelegate {
    func insertItem(tvTag: Int, tag: Int)
    func focusCell(tvTag: Int, cellTag: Int)
    func removeItem(tvTag: Int, tag: Int)
    func check(tvTag: Int, cellTag: Int)
    func hideDelBtn(tvTag: Int, tag: Int)
    func saveData(text: String, tvTag: Int, tag: Int)
    func reloadTVConstant()
}
