//
//  Alert+Extention.swift.swift
//  SeSAC_ShoppingList
//
//  Created by ChanhoHwang on 2021/11/03.
//

import UIKit

extension UIViewController {
    func activateAlert(sortByToDo: @escaping () -> (), sortByFavourite: @escaping () -> (), sortByName: @escaping () -> ()) {
        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let sortByToDo = UIAlertAction(title: "할 일 기준정렬", style: .default) { _ in
            print("할 일 기준정렬")
            sortByToDo()
        }
        
        let sortByFavourite = UIAlertAction(title: "즐겨찾기순 정렬", style: .default) { _ in
            print("즐겨찾기순 정렬")
            sortByFavourite()
        }
        
        let sortByName = UIAlertAction(title: "제목순 정렬", style: .default) { _ in
            print("제목순 정렬")
            sortByName()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [sortByToDo, sortByFavourite, sortByName, cancel].forEach { action in
            actionAlert.addAction(action)
        }
        
        present(actionAlert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, okTitle: String, okAction: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: okTitle, style: .default) { _ in
            print("확인 버튼 눌렀음")
            okAction()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true) {
            print("얼럿이 떴습니다.")
        }
    }
    
    func showToast(message : String) {
        let width_variable:CGFloat = 10
        
        let toastLabel = UILabel(frame: CGRect(x: width_variable, y: self.view.frame.size.height-100, width: view.frame.size.width-2*width_variable, height: 35))
        // 뷰가 위치할 위치를 지정해준다. 여기서는 아래로부터 100만큼 떨어져있고, 너비는 양쪽에 10만큼 여백을 가지며, 높이는 35로
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
