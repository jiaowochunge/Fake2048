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
    fileprivate var saveRecords: [History]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.backgroundColor = UIColor.groupTableViewBackground
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "SaveGameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        // 配置表格
        let layout = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 15, left: 10, bottom: 55, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let width = (self.view.frame.size.width - 10 * 2 - 20) / 3 - 1
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)

        // 查询保存记录
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        saveRecords = appDelegate.modelController.fetchRecords()
        
        // 工具栏
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.height - 44, width: self.view.frame.width, height: 44))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SaveGameCollectionViewController.cancelSelectRecord(_:)))
        toolbar.setItems([cancelButton], animated: false)
        self.view.addSubview(toolbar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 隐藏状态栏
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    /// 取消加载历史记录
    func cancelSelectRecord(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 删除历史记录
    func deleteRecord(_ sender: AnyObject) {
        // 这是个button。我手贱，本来直接声明称UIButton就行了，我非要声明成AnyObject，再强转成UIButton，真是折腾
        guard let button = sender as? UIButton else {
            return
        }
        // 保险起见，转换的点为（10，10）
        let touchPoint = button.convert(CGPoint(x: 10, y: 10), to: self.collectionView)
        guard let indexPath = self.collectionView?.indexPathForItem(at: touchPoint) else {
            return
        }
        let alert = UIAlertController(title: nil, message: "确定删除该记录？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) -> Void in
            // 删除记录
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.modelController.deleteRecord(self.saveRecords.remove(at: indexPath.item))
            // 刷新视图
            self.collectionView?.deleteItems(at: [indexPath])
        }))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return saveRecords.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SaveGameCollectionViewCell
    
        cell.record = saveRecords[indexPath.item]
        cell.deleteButton.addTarget(self, action: #selector(SaveGameCollectionViewController.deleteRecord(_:)), for: .touchUpInside)
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true) { () -> Void in
            self.selectRecordHandler?(self.saveRecords[indexPath.item])
            // 打断可能存在的强引用
            self.selectRecordHandler = nil
        }
    }

}
