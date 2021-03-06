//
//  SaveGameCollectionViewCell.swift
//  Fake2048
//
//  Created by john on 16/6/15.
//  Copyright © 2016年 BOLO. All rights reserved.
//

import UIKit

class SaveGameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var screenShot: UIImageView!
    
    @IBOutlet var modifyTime: UILabel!
    
    @IBOutlet var deleteButton: UIButton!
    
    /// 计算属性，并不存储什么，其实本质是个setter方法
    var record: History? {
        set {
            if let h = newValue {
                screenShot.image = UIImage(data: h.screen_shot! as Data)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
                modifyTime.text = dateFormatter.string(from: h.modify_date! as Date)
            } else {
                screenShot.image = nil
                modifyTime.text = nil
            }
        }
        get {
            return nil
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
