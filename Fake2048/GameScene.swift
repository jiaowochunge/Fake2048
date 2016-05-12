//
//  GameScene.swift
//  Fake2048
//
//  Created by john on 16/5/10.
//  Copyright (c) 2016年 BOLO. All rights reserved.
//

import SpriteKit

let LowTile: CGFloat = 10
let MidTile: CGFloat = 20
let HighTile: CGFloat = 30

class GameScene: SKScene {
    
    var tileMap: [[Int]]!
    
    /// 方块容器
    var tileBoard: SKShapeNode!
    
    /// 方阵纬度
    let tileColumn: Int = 4
    
    /// 方块之间的间距
    let tileMargin: CGFloat = 10
    
    /// 方块长度
    var tileLength: CGFloat!
    
    var startMenu: SKShapeNode!
    
    var hasStartGame: Bool = false
    
    override func didMoveToView(view: SKView) {
        addDecorateNode()
        initGame()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    /**
     添加节点
     */
    func addDecorateNode() {
        self.backgroundColor = SKColor(white: 247 / 255.0, alpha: 1)
        // 屏幕尺寸
        let screenSize = UIScreen.mainScreen().bounds.size
        
        // 游戏区域划分：正方形主要游戏区域在中间，剩下高度，2/3在上，1/3在下
        var boardRect = CGRect(x: -screenSize.width / 2, y: -screenSize.width / 2, width: screenSize.width, height: screenSize.width)
        // 缩进
        boardRect.insetInPlace(dx: 15, dy: 15)
        tileBoard = SKShapeNode(rect: boardRect, cornerRadius: 5)
        tileBoard.fillColor = SKColor(red: 174 / 255.0, green: 159 / 255.0, blue: 143 / 255.0, alpha: 1)
        tileBoard.position = CGPoint(x: screenSize.width / 2, y: (screenSize.height - screenSize.width) / 3 + screenSize.width / 2)
        self.addChild(tileBoard)
        
        // 文字提示
        let gameNameLabel = SKLabelNode(text: "2048")
        gameNameLabel.fontSize = 35
        gameNameLabel.fontName = "Arial-BoldMT"
        gameNameLabel.fontColor = SKColor(red: 99 / 255.0, green: 91 / 255.0, blue: 82 / 255.0, alpha: 1)
        gameNameLabel.verticalAlignmentMode = .Center
        gameNameLabel.horizontalAlignmentMode = .Left
        gameNameLabel.position = CGPoint(x: 15, y: screenSize.height - (screenSize.height - screenSize.width) / 3)
        self.addChild(gameNameLabel)
        
        let gameBrief = SKLabelNode(text: "获得 2048，你就赢了！")
        gameBrief.fontSize = 12
        gameBrief.fontName = "ArialMT"
        gameBrief.fontColor = SKColor(red: 99 / 255.0, green: 91 / 255.0, blue: 82 / 255.0, alpha: 1)
        gameBrief.verticalAlignmentMode = .Center
        gameBrief.horizontalAlignmentMode = .Left
        gameBrief.position = CGPoint(x: gameNameLabel.position.x, y: screenSize.height - (screenSize.height - screenSize.width) / 2)
        self.addChild(gameBrief)
        
        // 开始游戏
        startMenu = SKShapeNode(rect: CGRect(x: -37.5, y: -10, width: 75, height: 20), cornerRadius: 2)
        startMenu.strokeColor = SKColor(red: 124 / 255.0, green: 103 / 255.0, blue: 83 / 255.0, alpha: 1)
        startMenu.fillColor = startMenu.strokeColor
        startMenu.position = CGPoint(x: screenSize.width - 37.5 - gameBrief.position.x, y: gameBrief.position.y)
        self.addChild(startMenu)
        
        let startLabel = SKLabelNode(text: "Start Game")
        startLabel.fontSize = 12
        startLabel.fontName = "Arial-BoldMT"
        startLabel.fontColor = SKColor.whiteColor()
        startLabel.verticalAlignmentMode = .Center
        startLabel.position = CGPointZero
        startMenu.addChild(startLabel)
    }
    
    func initGame() {
        tileLength = (tileBoard.frame.size.width - CGFloat(tileColumn + 1) * tileMargin) / CGFloat(tileColumn)

        tileMap = {
            var tmpMap: [[Int]] = []
            for i in (0..<tileColumn) {
                var row: [Int] = []
                for j in (0..<tileColumn) {
                    row.append(0)
                    // 添加背景小方块
                    let tile = NumTile(length: tileLength)
                    tile.position = tilePosition(i, j)
                    tile.zPosition = LowTile
                    tileBoard.addChild(tile)
                }
                tmpMap.append(row)
            }
            return tmpMap
        }()
    }
    
    func startGame() {
        // 重新开始
        if hasStartGame {
            tileBoard.removeAllChildren()
            
            initGame()
        }
        hasStartGame = true
        
        let l = startMenu.children.first as! SKLabelNode
        l.text = "New Game"
        
        // 由两个方块起手
        for _ in (0..<2) {
            addNewTile()
        }
    }
    
    /**
     返回一个随机空白位置
     
     - returns: 该位置的坐标
     */
    func randomPosition() -> (Int, Int) {
        var remainRoom: Array<(Int, Int)> = []
        for i in (0..<tileColumn) {
            for j in (0..<tileColumn) {
                if tileMap[i][j] == 0 {
                    remainRoom.append((i, j))
                }
            }
        }
        return remainRoom[random() % remainRoom.count]
    }
    
    func tilePosition(x: Int, _ y: Int) -> CGPoint {
        /*** 数组方向是行列式方向
         | 11 12 13 14 |
         | 21 22 23 24 |
         | 31 32 33 34 |
         | 41 42 43 44 |
        */
        // 计算坐标
        var x1 = (CGFloat(y) + 1) * tileMargin + (CGFloat(y) + 0.5) * tileLength
        var y1 = (CGFloat(tileColumn - 1 - x) + 1) * tileMargin + (CGFloat(tileColumn - 1 - x) + 0.5) * tileLength
        // 由于父坐标系的锚点在中心，需要偏移
        x1 -= tileBoard.frame.size.width / 2
        y1 -= tileBoard.frame.size.width / 2
        return CGPoint(x: x1, y: y1)
    }
    
    func addNewTile() {
        let p = randomPosition()
        let t = NumTile(length: tileLength)
        t.position = tilePosition(p)
        t.name = "\(p.0),\(p.1)"
        t.zPosition = HighTile
        tileBoard.addChild(t)
        
        t.levelUp()
        // 标记方块
        tileMap[p.0][p.1] = t.level.rawValue
        
        NSLog("add tile at \(p)")
    }
}

extension GameScene {
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 反正不支持多点触控，直接取第一个触摸点
        guard let touch = touches.first else {
            return
        }
        // 找到触摸点
        let touchPoint = touch.locationInNode(self)
        // 是开始按钮
        if startMenu.containsPoint(touchPoint) {
            startGame()
        }
    }
}

extension GameScene: GameGestureProtocol {
    
    func swipeGesture(direction: UISwipeGestureRecognizerDirection) {
        if !hasStartGame {
            return
        }
        if direction == .Left {
            
        } else if direction == .Right {

        } else if direction == .Up {

        } else if direction == .Down {

        } else {
            assert(false)
        }
        // 是否有动作执行
        var hasAction = false
        // 算法：对每行依次执行算法，如果能移动，设置hasAction标识位，执行动作，随机空白位生成一个新的方块，判断是否game over。
        // 每行算法：对每列依次执行判断。如果位置是空白，下一个；否则从前一个位置直到开头位置的方块依次检测，如果是空白，说明可以移动，如果和本方块一样，说明可以升级，终止判断，必然不能移动到更前面了。
        // 采用两个数组辅助，statusMap是当前方块状态，levelUpMap代表判断过程中哪些方块要升级。status只负责移动方块判断，并不升级。因为如果前面遇到升级了，后面本不能升级的方块就能升级了。
        for i in 0..<tileColumn {
            // 行状态表
            var statusMap = tileMap[i]
            // 升级表
            var levelUpMap: [Bool] = Array<Bool>(count: tileColumn, repeatedValue: false)
            var hasRowAction = false
            for j in 0..<tileColumn {
                // 第一个方块不会移动，没有方块不用理会
                if j == 0 || statusMap[j] == 0 {
                    continue
                }
                // 移动目的地
                var moveDst = j
                // 是否能升级
                var canLevelUp = false
                // 倒序计算
                for k in 0...j-1 {
                    // 前一格是空格，可以前移
                    if statusMap[j - 1 - k] == 0 {
                        moveDst--
                    }
                        // 前一格和当前格数字相同，且没有升过级，可以升级，可以移动。终止判断，不可能再前移了
                    else if statusMap[j - 1 - k] == statusMap[j] && !levelUpMap[j - 1 - k] {
                        moveDst--
                        canLevelUp = true
                        break
                    }
                }
                // 没有移动
                if moveDst == j {
                    continue
                }
                hasRowAction = true
                hasAction = true
                
                // 当前方块
                let t = tileBoard.childNodeWithName("\(i),\(j)") as! NumTile
                // 能升级时，移动的方块是要在升级方块之下的，升级的动作由不动的方块执行
                if canLevelUp {
                    // 待升级方块
                    let lt = tileBoard.childNodeWithName("\(i),\(moveDst)") as! NumTile
                    // 更改层次结构
                    t.zPosition = MidTile
                    // 移动到目的地后直接移除掉。然后升级
                    t.runAction(SKAction.moveTo(tilePosition(i, moveDst), duration: 0.3), completion: { () -> Void in
                        t.removeFromParent()
                        lt.levelUp()
                    })
                } else {
                    // 移动到目的地
                    t.runAction(SKAction.moveTo(tilePosition(i, moveDst), duration: 0.3))
                    t.name = "\(i),\(moveDst)"
                }
                // 修改临时状态
                if canLevelUp {
                    levelUpMap[moveDst] = true
                } else {
                    statusMap[moveDst] = statusMap[j]
                }
                statusMap[j] = 0
            }
            if hasRowAction {
                // 修改地图状态
                var finalRow: [Int] = Array<Int>(count: tileColumn, repeatedValue: 0)
                for l in 0..<tileColumn {
                    finalRow[l] = levelUpMap[l] ? statusMap[l] + 1 : statusMap[l]
                }
                tileMap[i] = finalRow
            }
        }
        if hasAction {
            // 延迟0.3秒添加方块。意思是等移动动作完成后才添加新方块
            tileBoard.runAction(SKAction.waitForDuration(0.3), completion: { () -> Void in
                self.addNewTile()
            })
        }
    }
    
}
