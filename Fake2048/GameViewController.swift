//
//  GameViewController.swift
//  Fake2048
//
//  Created by john on 16/5/10.
//  Copyright (c) 2016年 BOLO. All rights reserved.
//

import UIKit
import SpriteKit

protocol GameGestureProtocol {
    func swipeGesture(direction: UISwipeGestureRecognizerDirection)
}

class GameViewController: UIViewController {
    
    var delegate: GameGestureProtocol?

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
