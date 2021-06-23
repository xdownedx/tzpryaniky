//
//  SelectorCell.swift
//  testForPryaniky
//
//  Created by adeleLover on 18.06.2021.
//

import UIKit

class SelectorCell: UICollectionViewCell {

    @IBOutlet weak var selectorPicker: UIPickerView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                UIView.animate(withDuration: 0.3) { // for animation effect
                     self.backgroundColor = UIColor(red: 115/255, green: 190/255, blue: 170/255, alpha: 1.0)
                }
            }
            else {
                UIView.animate(withDuration: 0.3) { // for animation effect
                     self.backgroundColor = UIColor(red: 236/255, green: 238/255, blue: 240/255, alpha: 1.0)
                }
            }
        }
    }
}
