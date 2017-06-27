//
//  NumTile.swift
//  Fake2048
//
//  Created by john on 16/5/10.
//  Copyright © 2016年 BOLO. All rights reserved.
//

import SpriteKit

/// 数字方块
class NumTile: SKNode {
    
    // 方块等级
    var level: TileLevel {
        didSet {
            numLabel.text = level.text
            numLabel.fontColor = level.textColor
            numLabel.fontSize = level.textSize
            
            backGround.fillColor = level.bgColor
            backGround.strokeColor = level.bgColor
        }
    }
    
    // 方块背景。只是一个单纯的颜色节点
    var backGround: SKShapeNode
    
    // 方块显示的数字
    var numLabel: SKLabelNode
    
    init(length: CGFloat) {
        level = .l0
        
        backGround = SKShapeNode(rect: CGRect(x: -length / 2, y: -length / 2, width: length, height: length), cornerRadius: 3)
        backGround.fillColor = level.bgColor
        backGround.strokeColor = level.bgColor
        
        numLabel = SKLabelNode(text: level.text)
        numLabel.fontColor = level.textColor
        numLabel.fontSize = level.textSize
        numLabel.fontName = "Arial-BoldMT"
        // 垂直居中。默认值不垂直
        numLabel.verticalAlignmentMode = .center
        
        super.init()
        
        // 绘制顺序由添加顺序决定，不设置 zPosition 了
        self.addChild(backGround)
        self.addChild(numLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 升级
    func levelUp() {
        level.nextLevel()
        // 动画效果。先放大10%，再恢复原样
        numLabel.text = level.text
        numLabel.fontColor = level.textColor
        numLabel.fontSize = level.textSize
        
        backGround.fillColor = level.bgColor
        backGround.strokeColor = level.bgColor
        
        let scale = SKAction.scale(by: 1.1, duration: 0.1)
        self.run(SKAction.sequence([scale, scale.reversed()]))
    }
    
}

/// 方块等级
enum TileLevel: Int {
    
    case l0 = 0, l1 = 1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15
    
    /// 只读计算属性。方块背景色
    var bgColor: SKColor {
        get {
            switch self {
            case .l0:
                return SKColor(red: 192 / 255.0, green: 179 / 255.0, blue: 165 / 255.0, alpha: 1)
            case .l1:
                return SKColor(red: 233 / 255.0, green: 222 / 255.0, blue: 209 / 255.0, alpha: 1)
            case .l2:
                return SKColor(red: 230 / 255.0, green: 217 / 255.0, blue: 186 / 255.0, alpha: 1)
            case .l3:
                return SKColor(red: 237 / 255.0, green: 161 / 255.0, blue: 102 / 255.0, alpha: 1)
            case .l4:
                return SKColor(red: 240 / 255.0, green: 130 / 255.0, blue: 80 / 255.0, alpha: 1)
            case .l5:
                return SKColor(red: 230 / 255.0, green: 100 / 255.0, blue: 70 / 255.0, alpha: 1)
            case .l6:
                return SKColor(red: 229 / 255.0, green: 70 / 255.0, blue: 38 / 255.0, alpha: 1)
            case .l7:
                return SKColor(red: 228 / 255.0, green: 198 / 255.0, blue: 86 / 255.0, alpha: 1)
            case .l8:
                return SKColor(red: 232 / 255.0, green: 195 / 255.0, blue: 79 / 255.0, alpha: 1)
            case .l9:
                return SKColor(red: 231 / 255.0, green: 190 / 255.0, blue: 64 / 255.0, alpha: 1)
            default:
                return SKColor(red: 237 / 255.0, green: 194 / 255.0, blue: 46 / 255.0, alpha: 1)
            }
        }
    }
    
    /// 只读计算属性。方块显示文字
    var text: String {
        get {
            if self == .l0 {
                return ""
            }
            var sum = 1
            for _ in (0..<self.rawValue) {
                sum *= 2
            }
            return "\(sum)"
        }
    }
    
    /// 只读计算属性。文字颜色
    var textColor: SKColor {
        get {
            if self.rawValue < 3 {
                return SKColor.gray
            } else {
                return SKColor.white
            }
        }
    }
    
    var textSize: CGFloat {
        get {
            if self.rawValue < 10 {
                return 30
            } else {
                return 24
            }
        }
    }
    
    mutating func nextLevel() {
        switch self {
        case .l0:
            // 10%的机会到2，90%机会到1
            if arc4random() % 10 == 9 {
                self = .l2
            } else {
                self = .l1
            }
        default:
            // 升1级
            self = TileLevel(rawValue: self.rawValue + 1)!
        }
    }

}
