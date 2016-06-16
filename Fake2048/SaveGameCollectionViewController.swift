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
    
    /// 隐藏状态栏
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    /// 取消加载历史记录
    func cancelSelectRecord(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 删除历史记录
    func deleteRecord(sender: AnyObject) {
        // 这是个button。我手贱，本来直接声明称UIButton就行了，我非要声明成AnyObject，再强转成UIButton，真是折腾
        guard let button = sender as? UIButton else {
            return
        }
        // 保险起见，转换的点为（10，10）
        let touchPoint = button.convertPoint(CGPoint(x: 10, y: 10), toView: self.collectionView)
        guard let indexPath = self.collectionView?.indexPathForItemAtPoint(touchPoint) else {
            return
        }
        let alert = UIAlertController(title: nil, message: "确定删除该记录？", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: { (action) -> Void in
            // 删除记录
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.modelController.deleteRecord(self.saveRecords.removeAtIndex(indexPath.item))
            // 刷新视图
            self.collectionView?.deleteItemsAtIndexPaths([indexPath])
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return saveRecords.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SaveGameCollectionViewCell
    
        cell.record = saveRecords[indexPath.item]
        cell.deleteButton.addTarget(self, action: "deleteRecord:", forControlEvents: .TouchUpInside)
    
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
