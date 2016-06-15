//
//  GameViewController.swift
//  Fake2048
//
//  Created by john on 16/5/10.
//  Copyright (c) 2016年 BOLO. All rights reserved.
//

import UIKit
import SpriteKit

protocol GameActionProtocol {
    
    func swipeGesture(direction: UISwipeGestureRecognizerDirection)
    
    func loadGame(tileMap: [[Int]])
    
}

class GameViewController: UIViewController {
    
    var delegate: GameActionProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size:self.view.bounds.size)

        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
    
        skView.presentScene(scene)
        
        scene.gameDelegate = self
        delegate = scene
        
        // 添加手势
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: "swipeLeft:")
        leftSwipe.direction = [.Left, .Right]
        skView.addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: "swipeRight:")
        rightSwipe.direction = .Right
        skView.addGestureRecognizer(rightSwipe)
        let upSwipe = UISwipeGestureRecognizer(target: self, action: "swipeUp:")
        upSwipe.direction = [.Up, .Down]
        skView.addGestureRecognizer(upSwipe)
        let downSwipe = UISwipeGestureRecognizer(target: self, action: "swipeDown:")
        downSwipe.direction = .Down
        skView.addGestureRecognizer(downSwipe)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.resignFirstResponder()
    }
}

extension GameViewController {
    
    func swipeLeft(gesture: UIGestureRecognizer) {
        delegate?.swipeGesture(.Left)
    }
    
    func swipeRight(gesture: UIGestureRecognizer) {
        delegate?.swipeGesture(.Right)
    }
    
    func swipeUp(gesture: UIGestureRecognizer) {
        delegate?.swipeGesture(.Up)
    }
    
    func swipeDown(gesture: UIGestureRecognizer) {
        delegate?.swipeGesture(.Down)
    }
    
}

extension GameViewController: GameDelegateProtocol {
    
    func saveGameDelegate() {
        
    }
    
    func loadGameDelegate() {
        let vc = SaveGameCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.selectRecordHandler = {
            (record: History) in
            
            // 根据 "," 分割字符串，将分隔后的字符串强转 Int
            let tileMap1 = record.tile_map!.characters.split(",").map { Int(String($0))! }
            // [Int] -> [[Int]]。分割成4个一组，将来需要修改
            var tileMap2: [[Int]] = []
            for i in 0..<4 {
                let s = i * 4, e = i * 4 + 4
                let t = tileMap1[s..<e]
                tileMap2.append(Array<Int>(t))
            }
            self.delegate?.loadGame(tileMap2)
        }
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}
