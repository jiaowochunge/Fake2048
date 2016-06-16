//
//  SaveGameCollectionViewController.swift
//  Fake2048
//
//  Created by john on 16/6/15.
//  Copyright © 2016年 BOLO. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SaveGameCollectionViewController: UICollectionViewController {
    
    /// 回调方法
    var selectRecordHandler: ((History) -> ())?
    
    /// 数据源
    private var saveRecords: [History]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.backgroundColor = UIColor.groupTableViewBackgroundColor()
        // Register cell classes
        self.collectionView!.registerNib(UINib(nibName: "SaveGameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        // 配置表格
        let layout = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 15, left: 10, bottom: 55, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let width = (self.view.frame.size.width - 10 * 2 - 20) / 3 - 1
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)

        // 查询保存记录
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        saveRecords = appDelegate.modelController.fetchRecords()
        
        // 工具栏
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: CGRectGetHeight(self.view.frame) - 44, width: CGRectGetWidth(self.view.frame), height: 44))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelSelectRecord:")
        toolbar.setItems([cancelButton], animated: false)
        self.view.addSubview(toolbar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelSelectRecord(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return saveRecords.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SaveGameCollectionViewCell
    
        cell.record = saveRecords[indexPath.item]
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.selectRecordHandler?(self.saveRecords[indexPath.item])
            // 打断可能存在的强引用
            self.selectRecordHandler = nil
        }
    }

}
