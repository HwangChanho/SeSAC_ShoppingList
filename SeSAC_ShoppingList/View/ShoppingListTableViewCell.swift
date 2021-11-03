//
//  ShoppingListTableViewCell.swift
//  SeSAC_Week03
//
//  Created by ChanhoHwang on 2021/10/14.
//

import UIKit

protocol ShoppingListTableViewCellDelegate {
    func selectedCheckBtn(index: Int)
    func selectedFavouriteBtn(index: Int)
}

class ShoppingListTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var textShowLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var index: Int = 0
    var delegate: ShoppingListTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func checkBtnPressed(_ sender: UIButton) {
        self.delegate?.selectedCheckBtn(index: index) // 인덱스 넘겨주기
    }
    
    @IBAction func favouriteBtnPressed(_ sender: UIButton) {
        self.delegate?.selectedFavouriteBtn(index: index) // 인덱스 넘겨주기
    }
}
