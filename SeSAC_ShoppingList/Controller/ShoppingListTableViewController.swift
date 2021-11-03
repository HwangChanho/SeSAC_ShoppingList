//
//  ShoppingListTableViewController.swift
//  SeSAC_Week03
//
//  Created by ChanhoHwang on 2021/10/14.
//

import UIKit
import RealmSwift

class ShoppingListTableViewController: UITableViewController, ShoppingListTableViewCellDelegate {
    
    let localRealm = try! Realm()
    let realmManager = RealmManager()
    
    var tasks: Results<ShoppingList>! {
        didSet {
            tableView.reloadData()
        }
    }
    
    var sortTasks: Results<ShoppingList>!
    
    func selectedFavouriteBtn(index: Int) {
        print(#function)
        var favourite = tasks[index].favourite // 직접 접근이 안 된다.
        if favourite {
            favourite = false
            realmManager.updateFavourite(index: index + 1, favourite: false)
        } else {
            favourite = true
            realmManager.updateFavourite(index: index + 1, favourite: true)
        }
        tableView.reloadData()
    }
    
    func selectedCheckBtn(index: Int) {
        print(#function)
        var buyCheck = tasks[index].buyCheck
        if buyCheck {
            buyCheck = false
            realmManager.updateBuyCheck(index: index + 1, buyCheck: false)
        } else {
            buyCheck = true
            realmManager.updateBuyCheck(index: index + 1, buyCheck: true)
        }
        tableView.reloadData()
    }
    
    let textField = UITextField()
    let headerView = UIView()
    let insertButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        navigationItem.title = "쇼핑"
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(sort(_:)))
        
        tasks = localRealm.objects(ShoppingList.self)
        print("Realm is located at:", localRealm.configuration.fileURL!)
        print(tasks)
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func setup() {
        textField.backgroundColor = .systemGray6
        textField.textColor = .systemGray2
        textField.font = .systemFont(ofSize: 15)
        textField.text = "무엇을 구매하실 건가요?"
        textField.layer.cornerRadius = 6
        textField.addLeftPadding()
        textField.clearsOnBeginEditing = true
        
        insertButton.setTitle("추가", for: .normal)
        insertButton.setTitleColor(.black, for: .normal)
        insertButton.backgroundColor = .systemGray5
        insertButton.layer.cornerRadius = 6
        insertButton.addTarget(self, action: #selector(add(_:)), for: .touchUpInside)
    }
    
    @objc func add(_: Any) {
        if textField.text != nil {
            realmManager.create(index: tasks.count + 1, shoppingList: textField.text!, buyCheck: false, favourite: false)
            tableView.reloadData()
        }
    }
    
    @objc func sort(_ sender: UIButton) {
        activateAlert {
            self.sortTasks = self.tasks.sorted(byKeyPath: "buyCheck", ascending: false)
            self.tasks = self.sortTasks
        } sortByFavourite: {
            self.sortTasks = self.tasks.sorted(byKeyPath: "favourite", ascending: false)
            self.tasks = self.sortTasks
//            self.tasks.sorted { (first, second) -> Bool in
//                if first.favourite == true {
//                    if first.favourite != second.favourite {
//                        return !second.favourite
//                    }
//                } else {
//                    if first.favourite != second.favourite {
//                        return !first.favourite
//                    }
//                }
//                return true
//            }
        } sortByName: {
            self.sortTasks = self.tasks.sorted(byKeyPath: "shoppingList", ascending: true)
            self.tasks = self.sortTasks
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    // header view start
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView.addSubview(textField)
        headerView.addSubview(insertButton)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: headerView.topAnchor),
            textField.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            textField.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -10)
        ])
        
        insertButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            insertButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15),
            insertButton.widthAnchor.constraint(equalToConstant: 50),
            insertButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -20),
            insertButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -15),
        ])
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    // header view end
    
    // default = 1, 섹션 수: numberOfSections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let bounds = UIScreen.main.bounds // 글자 제한용
        let width = bounds.width
        
        tableView.backgroundColor = .white
        
        // 타입 캐스팅
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingView", for: indexPath) as? ShoppingListTableViewCell else { return UITableViewCell() }
        
        cell.index = indexPath.row
        cell.delegate = self       // 셀의 인덱스를 전달?
        
        cell.accessoryType = .none
        
        let row = tasks[indexPath.row]
        
        if row.buyCheck == true {
            cell.checkBoxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        } else {
            cell.checkBoxButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
        cell.checkBoxButton.setTitle("", for: .normal)
        cell.checkBoxButton.tintColor = .black
        
        cell.textShowLabel.text = row.shoppingList
        cell.textShowLabel.textColor = .black
        cell.textShowLabel.font = .systemFont(ofSize: 10)
        cell.textShowLabel.sizeToFit()
        cell.textShowLabel.preferredMaxLayoutWidth = width - 110
        
        if row.favourite == true {
            cell.favouriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            cell.favouriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        cell.favouriteButton.setTitle("", for: .normal)
        cell.favouriteButton.tintColor = .black
        
        return cell
    }
    
    // 셀의 높이 동적으로 설정
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView.rowHeight
    }
    
    // 셀의 편집상태 관리 (on/off 여부): canEditRowAt
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // indexPath.section == 0 ? false : true
        return true
    }
    
    // 셀 삭제시 동작 구현: editingStyle
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            print("remove")
            tableView.reloadData()
        }
    }
}

extension UITextField { // 왼쪽 값 패딩을 위해 사용
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height)) // 간격
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always // 텍스트필드 왼쪽의 안 보이는 뷰를 나타내줌
    }
}
