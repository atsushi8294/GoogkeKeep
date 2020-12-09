//
//  ViewController.swift
//  GoogleKeep
//
//  Created by 石橋惇 on 2020/11/16.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var todoListTV: UITableView!
    @IBOutlet weak var checkedTV: UITableView!
    @IBOutlet weak var todoTVConstraints: NSLayoutConstraint!
    @IBOutlet weak var checkedTVConstrains: NSLayoutConstraint!
    @IBOutlet weak var checkedHeader: UIView!
    @IBOutlet weak var checkedHeaderLbl: UILabel!
    
    
    /// 全てのTodoのデータを格納
    var allTodoData:[TodoData] = []
    /// Todoデータのみを格納
    var todoList:[TodoData] = []
    /// チェックされたデータを格納
    var checkedList:[TodoData] = []
    
    
    let TodoListTVTag = 0
    let CheckedListTVTag = 1
    let TodoCellID = "todoCell"
    let CheckedCellID = "checkedCell"
    let CellHeight: CGFloat = 40
    var tvTag = 0
    var crrCellTag = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setUpTV()
    }
    
    
    func setUpViews() {
        switchCheckListHeader()
    }
    
    
    func debugShowData() {
        print("\n===== All Data =====　")
        for (i, item) in allTodoData.enumerated() {
            print("\(i): \(item.title!)")
        }
        
        print("===== Todo List =====　")
        for (i, item) in todoList.enumerated(){
            print("\(i): \(item.title!)")
        }

        print("===== Checked List =====　")
        for (i, item) in checkedList.enumerated(){
            print("\(i): \(item.title!)")
        }
    }
    
    
    /// 現在編集中のtvのListを返す
    /// - Returns: tvTagに基づいた配列
    func getList() -> Array<TodoData> {
        if tvTag == TodoListTVTag {
            return todoList
        } else if tvTag == CheckedListTVTag {
            return checkedList
        }
        return Array()
    }
    
    
    /// tag番目のTodoCellを返す
    /// - Parameter tag: 取得したいセルの添字
    /// - Returns: tag番目のTodoCell
    func getTodoCell(_ tag: Int) -> TodoCell {
        let indexPath = IndexPath(row: tag, section: 0)
        let cell = todoListTV.cellForRow(at: indexPath) as! TodoCell
        return cell
    }
    
    
    /// tag番目のCheckedCellを返す
    /// - Parameter tag: 取得したいセルの添字
    /// - Returns:　tag番目のCheckedCell
    func getCheckedCell(_ tag: Int) -> CheckedCell {
        let indexPath = IndexPath(row: tag, section: 0)
        let cell = checkedTV.cellForRow(at: indexPath) as! CheckedCell
        return cell
    }
    
    
    /// TableViewTagに基づいたTableViewを返す
    /// - Returns: タグに基づいたTableView
    func getTV() -> UITableView {
        if tvTag == TodoListTVTag {
            return todoListTV
        } else if tvTag == CheckedListTVTag {
            return checkedTV
        }
        return UITableView()
    }
    
    
    /// Todoのデータを振り分け直す
    func reloadTodoData() {
        todoList.removeAll()
        checkedList.removeAll()
        
        for item in allTodoData {
            if item.isDone == false {
                todoList.append(item)
            } else {
                checkedList.append(item)
            }
        }
    }


    /// allTodoDataのItemインスタンスのタグを昇順に並べる
    func resetDataTag() {
        for (i, item) in allTodoData.enumerated() {
            item.setTag(tag: i)
        }
    }


    /// 全TVのセルタグを昇順に振り分け直す
    func resetCellTag() {
        for _ in 0..<2 {
            let count = getTV().numberOfRows(inSection: 0)
            for i in 0..<count {
                let indexPath = IndexPath(row: i, section: 0)
                let cell = getTV().cellForRow(at: indexPath)
                cell?.tag = i
            }
            switchTV()
        }
    }
    
    
    /// tvTagをもう一方のtvTagに変更
    func switchTV() {
        if tvTag == TodoListTVTag {
            tvTag = CheckedListTVTag
        } else if tvTag == CheckedListTVTag {
            tvTag = TodoListTVTag
        }
    }
    
    
    /// CheckedTVのヘッダーの表示・非表示を切り替える
    func switchCheckListHeader() {
        if checkedList.count != 0 {
            checkedHeader.isHidden = false
            checkedHeaderLbl.text = "\(checkedList.count) 個の選択中アイテム"
        } else {
            checkedHeader.isHidden = true
        }
    }

    
    @IBAction func switchHideCheckedList(_ sender: Any) {
        // MARK: 追加機能
        // bottomArrowを反転させる
        checkedTV.isHidden = !checkedTV.isHidden
    }
    
    
    
    @IBAction func addItem(_ sender: Any) {
        insertItem(tvTag: 0, tag: todoList.count)
    }
}









extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setUpTV() {
        todoListTV.delegate = self
        todoListTV.dataSource = self
        todoListTV.register(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: TodoCellID)
        todoListTV.allowsSelection = false
        
        checkedTV.delegate = self
        checkedTV.dataSource = self
        checkedTV.register(UINib(nibName: "CheckedCell", bundle: nil), forCellReuseIdentifier: CheckedCellID)
        checkedTV.allowsSelection = false
        
        todoTVConstraints.constant = CellHeight * CGFloat(todoList.count)
        checkedTVConstrains.constant = CellHeight * CGFloat(checkedList.count)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == TodoListTVTag {
            return todoList.count
        } else if tableView.tag == CheckedListTVTag {
            return checkedList.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == TodoListTVTag {
            let cell = todoListTV.dequeueReusableCell(withIdentifier: TodoCellID, for: indexPath) as! TodoCell
            cell.delegate = self
            cell.tag = indexPath.row
            cell.todoCellLbl.text = todoList[indexPath.row].title
            if tvTag == TodoListTVTag && crrCellTag == indexPath.row {
                cell.todoCellLbl.becomeFirstResponder()
            }
            return cell
        } else if tableView.tag == CheckedListTVTag {
            let cell = checkedTV.dequeueReusableCell(withIdentifier: CheckedCellID, for: indexPath) as! CheckedCell
            cell.delegate = self
            cell.tag = indexPath.row
            cell.cellLbl.text = checkedList[indexPath.row].title
            if tvTag == CheckedListTVTag && crrCellTag == indexPath.row {
                cell.cellLbl.becomeFirstResponder()
            }
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = CellHeight
        return UITableView.automaticDimension
    }
    
}











// MARK: OperationCellDelegate
extension ViewController: OperationCellDelegate {


    /// TableViewの高さをリロードする
    func reloadTVConstant() {
        print("\n\n===== Reload TV Constant ======")
        var todoHeight: CGFloat = 0
        var checkedHeight: CGFloat = 0
        
        for (item) in todoList {
            todoHeight += item.height
        }
        for (item) in checkedList {
            checkedHeight += item.height
        }
        
        todoTVConstraints.constant = CellHeight * CGFloat(todoList.count) + todoHeight
        checkedTVConstrains.constant = CellHeight * CGFloat(checkedList.count) + checkedHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        todoListTV.performBatchUpdates(nil) { (finished) in
            todoHeight = 0
            for (i, item) in self.todoList.enumerated() {
                item.setHeight(height: self.getTodoCell(i).frame.height - self.CellHeight)
                todoHeight += item.height
                self.todoTVConstraints.constant = self.CellHeight * CGFloat(self.todoList.count) + todoHeight
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        }
        
        checkedTV.performBatchUpdates(nil) { (finished) in
            checkedHeight = 0
            for (i, item) in self.checkedList.enumerated() {
                item.setHeight(height: self.getCheckedCell(i).frame.height - self.CellHeight)
                checkedHeight += item.height
                self.checkedTVConstrains.constant = self.CellHeight * CGFloat(self.checkedList.count) + checkedHeight
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    

    /// 選択中のセル以外のXボタンを非表示にする
    /// - Parameters:
    ///   - tvTag: 選択中のセルのTVTag
    ///   - tag: 選択中のセルのタグ
    func hideDelBtn(tvTag: Int, tag: Int) {
        self.tvTag = tvTag
        crrCellTag = tag

        todoListTV.performBatchUpdates(nil) { (finished) in
            for (i, _) in self.todoList.enumerated() {
                let cell = self.getTodoCell(i)
                cell.delBtn.isHidden = cell.todoCellLbl.isFirstResponder ? false : true
            }
        }

        checkedTV.performBatchUpdates(nil) { (finished) in
            for (i, _) in self.checkedList.enumerated() {
                let cell = self.getCheckedCell(i)
                cell.delBtn.isHidden = cell.cellLbl.isFirstResponder ? false : true
            }
        }
    }


    /// Todoリストにアイテムを追加する
    /// - Parameters:
    ///   - text: 追加するアイテムの文字列
    ///   - tvTag: 追加するTVのタグ
    ///   - tag: 追加する位置
    func insertItem(tvTag: Int, tag: Int) {

        // MARK: text要らなくね？

        print("\n\n===== セルの挿入 =====")
        self.tvTag = tvTag
        
        let todoData = TodoData(title: "", tag: tag)
        let indexPath = IndexPath(row: tag, section: 0)
        var insertTag = 0

        if tvTag == TodoListTVTag && todoList.count != 0 {
            insertTag = todoList[tag-1].tag + 1
        } else if tvTag == CheckedListTVTag && checkedList.count != 0 {
            insertTag = checkedList[tag-1].tag + 1
            todoData.isDone = true
        }

        allTodoData.insert(todoData, at: insertTag)
        resetDataTag()
        reloadTodoData()
        getTV().insertRows(at: [indexPath], with: .automatic)
        reloadTVConstant()
        resetCellTag()
        focusCell(tvTag: tvTag, cellTag: tag)
    }


    /// セルにフォーカスする
    /// - Parameter tvTag: TableViewのタグ
    /// - Parameter cellTag: フォーカスするセルのタグ
    func focusCell(tvTag: Int, cellTag: Int) {
        crrCellTag = cellTag
        if tvTag == TodoListTVTag && todoList.count != 0 {
            todoListTV.performBatchUpdates(nil, completion: { (finished) in
                self.getTodoCell(cellTag).todoCellLbl.becomeFirstResponder()
            })
        } else if tvTag == CheckedListTVTag && checkedList.count != 0 {
            checkedTV.performBatchUpdates(nil, completion: { (finished) in
                self.getCheckedCell(cellTag).cellLbl.becomeFirstResponder()
            })
        }
    }


    /// Todoリスト・TableViewからアイテムを削除する
    /// - Parameter tvTag: 削除するセルのTV
    /// - Parameter tag: 削除する位置
    func removeItem(tvTag: Int, tag: Int) {
        print("\n\n===== セルの削除 =====")
        self.tvTag = tvTag
        resetDataTag()
        
        for item in allTodoData {
            if getList()[tag].tag == item.tag {
                allTodoData.remove(at: item.tag)
            }
        }
        reloadTodoData()
        getTV().deleteRows(at: [IndexPath(row: tag, section: 0)], with: .automatic)
        reloadTVConstant()
        resetCellTag()
        switchCheckListHeader()
    }


    /// データを保存する
    /// - Parameters:
    ///   - text: 保存する文字列
    ///   - tag: 入力されたセルのタグ
    ///   - tvTag: 入力されたTableViewのタグ
    func saveData(text: String, tvTag: Int, tag: Int) {
        print("\n\n・文字列の保存: \(text)")
        for item in allTodoData {
            if tvTag == CheckedListTVTag && checkedList[tag].tag == item.tag && item.isDone == true ||
                tvTag == TodoListTVTag && todoList[tag].tag == item.tag && item.isDone == false {
                item.title = text
            }
        }
        debugShowData()
    }


    /// チェックボタンが押された時の処理
    /// - Parameters:
    ///   - cellTag: チェックするセルのタグ
    ///   - tvTag: チェックするTableViewのタグ
    func check(tvTag: Int, cellTag: Int) {
        self.tvTag = tvTag

        print("\n\n\n===== チェック =====")
        print("// TV Tag: \(self.tvTag)")
        print("// Cell Tag: \(cellTag)")
        print("// crrCellTag: \(crrCellTag)")

        let item = getList()[cellTag]
        item.isDone = !item.isDone

        resetDataTag()
        reloadTodoData()
        getTV().deleteRows(at: [IndexPath(row: cellTag, section: 0)], with: .automatic)
        switchTV()

        for (i, todo) in getList().enumerated() {
            if todo.tag == item.tag {
                getTV().insertRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
                switchTV()
            }
        }

        switchTV()
        reloadTVConstant()
        switchTV()
        resetCellTag()
        switchCheckListHeader()
        
        if cellTag < crrCellTag {
            crrCellTag -= 1
        } else if crrCellTag == cellTag {
            hideDelBtn(tvTag: tvTag, tag: -1)
            return
        }

        hideDelBtn(tvTag: tvTag, tag: crrCellTag)

        debugShowData()
        self.tvTag = tvTag
    }
    
}
