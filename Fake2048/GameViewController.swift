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
    
    func swipeGesture(_ direction: UISwipeGestureRecognizerDirection)
    
    func loadGame(_ c: GameContext)
    
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
        scene.scaleMode = .aspectFill
    
        skView.presentScene(scene)
        
        scene.gameDelegate = self
        delegate = scene
        
        // 添加手势
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.swipeLeft(_:)))
        leftSwipe.direction = [.left, .right]
        skView.addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.swipeRight(_:)))
        rightSwipe.direction = .right
        skView.addGestureRecognizer(rightSwipe)
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.swipeUp(_:)))
        upSwipe.direction = [.up, .down]
        skView.addGestureRecognizer(upSwipe)
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.swipeDown(_:)))
        downSwipe.direction = .down
        skView.addGestureRecognizer(downSwipe)
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.resignFirstResponder()
    }
}

extension GameViewController {
    
    func swipeLeft(_ gesture: UIGestureRecognizer) {
        delegate?.swipeGesture(.left)
    }
    
    func swipeRight(_ gesture: UIGestureRecognizer) {
        delegate?.swipeGesture(.right)
    }
    
    func swipeUp(_ gesture: UIGestureRecognizer) {
        delegate?.swipeGesture(.up)
    }
    
    func swipeDown(_ gesture: UIGestureRecognizer) {
        delegate?.swipeGesture(.down)
    }
    
}

extension GameViewController: GameDelegateProtocol {
    
    func saveGameDelegate() {
        
    }
    
    func loadGameDelegate() {
        let vc = SaveGameCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.selectRecordHandler = {
            (record: History) in
            self.delegate?.loadGame(GameContext(record: record))
        }
        self.present(vc, animated: true, completion: nil)
    }
    
}
