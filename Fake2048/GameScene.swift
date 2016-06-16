//
//  GameScene.swift
//  Fake2048
//
//  Created by john on 16/5/10.
//  Copyright (c) 2016年 BOLO. All rights reserved.
//

import SpriteKit

let showTinyMap = true

let LowTile: CGFloat = 10
let MidTile: CGFloat = 20
let HighTile: CGFloat = 30

/**
 *	游戏进程代理
 */
protocol GameDelegateProtocol {
    
    func saveGameDelegate()
    
    func loadGameDelegate()
    
}

class GameScene: SKScene {
    
    var gameDelegate: GameDelegateProtocol!
    
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
    
    var loadMenu: SKShapeNode!
    
    var saveMenu: SKShapeNode!
    
    var hasStartGame: Bool = false
    
    var gameOver = false
    
    // 小地图
    var tinyMap: SKLabelNode!
    
    // 这个线程安全吗？
    var actionCount: Int = 0
    
    override func didMoveToView(view: SKView) {
        addDecorateNode()
        initGame()
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
        
        if showTinyMap {
            tinyMap = SKLabelNode(text: nil)
            tinyMap.fontSize = 10
            tinyMap.fontName = "ArialMT"
            tinyMap.fontColor = SKColor.blackColor()
            tinyMap.verticalAlignmentMode = .Center
            tinyMap.horizontalAlignmentMode = .Left
            tinyMap.position = CGPoint(x: gameNameLabel.position.x, y: (screenSize.height - screenSize.width) / 6)
            self.addChild(tinyMap)
        }
        
        // 装载游戏
        loadMenu = SKShapeNode(rect: CGRect(x: -37.5, y: -10, width: 75, height: 20), cornerRadius: 2)
        loadMenu.strokeColor = SKColor(red: 124 / 255.0, green: 103 / 255.0, blue: 83 / 255.0, alpha: 1)
        loadMenu.fillColor = loadMenu.strokeColor
        loadMenu.position = CGPoint(x: 15 + CGRectGetWidth(loadMenu.frame) * 0.5, y: (screenSize.height - screenSize.width) / 3 - 20)
        self.addChild(loadMenu)
        
        let loadLabel = SKLabelNode(text: "Load Game")
        loadLabel.fontSize = 12
        loadLabel.fontName = "Arial-BoldMT"
        loadLabel.fontColor = SKColor.whiteColor()
        loadLabel.verticalAlignmentMode = .Center
        loadLabel.position = CGPointZero
        loadMenu.addChild(loadLabel)
        
        // 保存游戏
        saveMenu = SKShapeNode(rect: CGRect(x: -37.5, y: -10, width: 75, height: 20), cornerRadius: 2)
        saveMenu.strokeColor = SKColor(red: 124 / 255.0, green: 103 / 255.0, blue: 83 / 255.0, alpha: 1)
        saveMenu.fillColor = saveMenu.strokeColor
        saveMenu.position = CGPoint(x: screenSize.width - 15 - CGRectGetWidth(saveMenu.frame) * 0.5, y: loadMenu.position.y)
        self.addChild(saveMenu)
        
        let saveLabel = SKLabelNode(text: "Save Game")
        saveLabel.fontSize = 12
        saveLabel.fontName = "Arial-BoldMT"
        saveLabel.fontColor = SKColor.whiteColor()
        saveLabel.verticalAlignmentMode = .Center
        saveLabel.position = CGPointZero
        saveMenu.addChild(saveLabel)
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
        if hasStartGame || gameOver {
            if gameOver {
                self.childNodeWithName("gameover")?.removeFromParent()
            }
            tileBoard.removeAllChildren()
            
            initGame()
            
            self.view?.undoManager?.removeAllActions()
        }
        gameOver = false
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
        
        logStatus()
    }
    
    func detectGameOver() -> Bool {
        // 还有0就还能玩
        var hasSpace = false
        for i in 0..<tileColumn {
            for j in 0..<tileColumn {
                if tileMap[i][j] == 0 {
                    hasSpace = true
                    break
                }
            }
        }
        if hasSpace {
            return false
        } else {
            // 已经没有空间了，检测是否有相邻的两个方块相同
            var alive = false
            for i in 0..<tileColumn {
                for j in 0..<tileColumn {
                    // 左侧
                    if j > 0 && tileMap[i][j] == tileMap[i][j - 1] {
                        alive = true
                        break
                    }
                    // 右侧
                    if j < tileColumn - 2 && tileMap[i][j] == tileMap[i][j + 1] {
                        alive = true
                        break
                    }
                    // 上边
                    if i > 0 && tileMap[i][j] == tileMap[i - 1][j] {
                        alive = true
                        break
                    }
                    // 下边
                    if i < tileColumn - 2 && tileMap[i][j] == tileMap[i + 1][j] {
                        alive = true
                        break
                    }
                }
            }
            return !alive
        }
    }
    
    /**
     打印游戏日志
     */
    func logStatus() {
        if showTinyMap {
            var s: String = ""
            NSLog("=============================")
            for i in 0..<tileColumn {
                var vs: String = "|"
                s += "|"
                for j in 0..<tileColumn {
                    s += " \(tileMap[i][j]) "
                    vs += " \(tileMap[i][j]) "
                }
                s += "|"
                vs += "|"
                NSLog(vs)
                s += "\n"
            }
            NSLog("=============================")
            tinyMap.text = s
        }
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
        } else if saveMenu.containsPoint(touchPoint) {
            if !hasStartGame || gameOver {
                return
            }
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.modelController.saveGame(tileMap)
            
            // 数据源是由自己管理的，外层controller不好处理。姑且通知下
            gameDelegate.saveGameDelegate()
        } else if loadMenu.containsPoint(touchPoint) {
            // 什么都不做，由外层controller处理
            gameDelegate.loadGameDelegate()
        }

    }
    
    func inAnimation() -> Bool {
        return actionCount != 0
    }
    
    func actionStart() {
        actionCount++
    }
    
    func actionFinish() {
        actionCount--
    }
    
    // 后退一步
    func restoreLastStep(state: [[Int]]) {
        let snapShot = tileMap
        self.view?.undoManager?.registerUndoWithTarget(self, selector: Selector("restoreLastStep:"), object: snapShot);
        
        tileBoard.removeAllChildren()
        
        tileMap = state
        for i in 0..<tileColumn {
            for j in 0..<tileColumn {
                // 添加背景小方块
                let tile = NumTile(length: tileLength)
                tile.position = tilePosition(i, j)
                tile.zPosition = LowTile
                tileBoard.addChild(tile)
                
                if tileMap[i][j] != 0 {
                    let t = NumTile(length: tileLength)
                    t.level = TileLevel(rawValue: tileMap[i][j])!
                    t.position = tilePosition(i, j)
                    t.name = "\(i),\(j)"
                    t.zPosition = HighTile
                    tileBoard.addChild(t)
                }
            }
        }
        
        logStatus()
    }
    
}

extension GameScene: GameActionProtocol {
    
    func swipeGesture(direction: UISwipeGestureRecognizerDirection) {
        
        // 变换坐标。这个变换是可逆的，变过去或变回来是同一个变换
        let transformPosition = {
            [unowned self] (x: Int, y: Int) -> (Int, Int) in
            if direction == .Left {
                // 无需变换
                return (x, y)
            } else if direction == .Right {
                // 子数组倒序
                return (x, self.tileColumn - 1 - y)
            } else if direction == .Up {
                // 旋转
                return (self.tileColumn - 1 - y, x)
            } else {
                // 旋转
                return (y, self.tileColumn - 1 - x)
            }
        }
        let transformPositionReverse = {
            [unowned self] (x: Int, y: Int) -> (Int, Int) in
            if direction == .Left {
                // 无需变换
                return (x, y)
            } else if direction == .Right {
                // 子数组倒序
                return (x, self.tileColumn - 1 - y)
            } else if direction == .Up {
                // 旋转
                return (y, self.tileColumn - 1 - x)
            } else {
                // 旋转
                return (self.tileColumn - 1 - y, x)
            }
        }
        if !hasStartGame || gameOver || inAnimation() {
            return
        }
        // 当前快照，用来支持undo操作
        let snapShot = tileMap
        // 方向向左时，二重循环访问的元素是正确的坐标，其他方向时访问坐标不对。我们对数组做对应变换
        var transformMap = tileMap
        // 方向向左时，不需要变换
        if direction != .Left {
            for i in 0..<tileColumn {
                for j in 0..<tileColumn {
                    let tp = transformPosition(i, j)
                    transformMap[tp.0][tp.1] = tileMap[i][j]
                }
            }
        }
        // 是否有动作执行
        var hasAction = false
        // 算法：对每行依次执行算法，如果能移动，设置hasAction标识位，执行动作，随机空白位生成一个新的方块，判断是否game over。
        // 每行算法：对每列依次执行判断。如果位置是空白，下一个；否则从前一个位置直到开头位置的方块依次检测，如果是空白，说明可以移动，如果和本方块一样，说明可以升级，终止判断，必然不能移动到更前面了。
        // 采用两个数组辅助，statusMap是当前方块状态，levelUpMap代表判断过程中哪些方块要升级。status只负责移动方块判断，并不升级。因为如果前面遇到升级了，后面本不能升级的方块就能升级了。
        for i in 0..<tileColumn {
            // 行状态表
            var statusMap = transformMap[i]
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
                    } else {
                        // 前一格和当前格数字相同，且没有升过级，可以升级，可以移动。终止判断，不可能再前移了
                        if statusMap[j - 1 - k] == statusMap[j] && !levelUpMap[j - 1 - k] {
                            moveDst--
                            canLevelUp = true
                        }
                        break
                    }
                }
                // 没有移动
                if moveDst == j {
                    continue
                }
                hasRowAction = true
                hasAction = true
                
                self.actionStart()
                // 当前方块。地图数组已经经过变换，但元素名没有经过变换，要定位回去
                let transformP = transformPositionReverse(i, j)
                // 目标地点
                let transformDstP = transformPositionReverse(i, moveDst)
                let t = tileBoard.childNodeWithName("\(transformP.0),\(transformP.1)") as! NumTile
                // 能升级时，移动的方块是要在升级方块之下的，升级的动作由不动的方块执行
                if canLevelUp {
                    // 待升级方块
                    let lt = tileBoard.childNodeWithName("\(transformDstP.0),\(transformDstP.1)") as! NumTile
                    // 更改层次结构
                    t.zPosition = MidTile
                    // 移动到目的地后直接移除掉。然后升级
                    t.runAction(SKAction.moveTo(tilePosition(transformDstP), duration: 0.2), completion: { () -> Void in
                        lt.levelUp()
                        t.removeFromParent()
                        self.actionFinish()
                    })
                    /** 修改名字。这里总算明白这个bug了。假设有某串数字是这样的"2, 2, 1, 1"，如果这里不修改名字，会产生这样一个bug:
                        1、第二个2与第一个2合并，忘了修改名字，第二个2名字序号依然是1
                        2、第一个1移动到｀1｀位，修改名字后序号是1，第二个1与第一个1合并，这时，第二个2与第一个1的名字是一样的，取错元素了，所以第二个升级动画失败
                        3、为了修复上述的bug，将这个即将remove的元素，名字改成一个特殊的索引，驱逐之。
                    */
                    t.name = "-1,-1"
                } else {
                    // 移动到目的地
                    t.runAction(SKAction.moveTo(tilePosition(transformDstP), duration: 0.2), completion: { () -> Void in
                        self.actionFinish()
                    })
                    // 修改名字。这个是立即执行的
                    t.name = "\(transformDstP.0),\(transformDstP.1)"
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
                transformMap[i] = finalRow
            }
        }
        if hasAction {
            // 注册undo操作
            self.view?.undoManager?.registerUndoWithTarget(self, selector: "restoreLastStep:", object: snapShot)
            // 恢复变换
            if direction == .Left {
                tileMap = transformMap
            } else {
                for i in 0..<tileColumn {
                    for j in 0..<tileColumn {
                        let tp = transformPositionReverse(i, j)
                        tileMap[tp.0][tp.1] = transformMap[i][j]
                    }
                }
            }
            // 延迟0.3秒添加方块。意思是等移动动作完成后才添加新方块
            tileBoard.runAction(SKAction.waitForDuration(0.2), completion: { () -> Void in
                self.addNewTile()
                if self.detectGameOver() {
                    let gameOver = SKLabelNode(text: "GAME OVER")
                    gameOver.fontSize = 35
                    gameOver.name = "gameover"
                    gameOver.fontName = "Arial-BoldMT"
                    gameOver.fontColor = SKColor.redColor()
                    gameOver.verticalAlignmentMode = .Center
                    gameOver.horizontalAlignmentMode = .Center
                    gameOver.position = CGPoint(x: self.size.width / 2, y: (self.size.height - self.size.width) / 6)
                    self.addChild(gameOver)
                    
                    self.gameOver = true
                }
            })
        }
    }
    
    func loadGame(tileMap: [[Int]]) {
        // 清理后退栈
        self.view?.undoManager?.removeAllActions()
        
        // 重新开始
        self.gameOver = false
        self.hasStartGame = true
        self.tileMap = tileMap
        
        tileBoard.removeAllChildren()

        for i in 0..<tileColumn {
            for j in 0..<tileColumn {
                // 添加背景小方块
                let tile = NumTile(length: tileLength)
                tile.position = tilePosition(i, j)
                tile.zPosition = LowTile
                tileBoard.addChild(tile)
                
                if tileMap[i][j] != 0 {
                    let t = NumTile(length: tileLength)
                    t.level = TileLevel(rawValue: tileMap[i][j])!
                    t.position = tilePosition(i, j)
                    t.name = "\(i),\(j)"
                    t.zPosition = HighTile
                    tileBoard.addChild(t)
                }
            }
        }
        
        logStatus()
    }
    
}
