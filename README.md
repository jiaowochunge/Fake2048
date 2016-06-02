#Fake2048
项目简介：曾经火热的2048小游戏，刚开始学swift时，当时有个热门的repo就是2048，这也只是个swift版本而已。<br/><br/>

####项目技术
- swift语言。苹果公司于2014年WWDC推出的语言，目前已经3.0版本了，我自学的时候好像是2.1，不多纠结。当时我看的是numbbbb翻译的版本，那时还是1.0版本的翻译，很多语法过时了。英文可以的话就直接看苹果官方文档吧。<https://developer.apple.com/swift/>
- sprite kit。只是个小游戏，用UIKit当然也可以，但我用的sprite kit实现的。这是苹果公司出个一个2D游戏引擎，语法很类似著名的cocos2D。自然还是推荐苹果官方文档<https://developer.apple.com/library/ios/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/Introduction/Introduction.html>
- NSUndoManager。这是NSFoundation中的一个类，用来方便的实现“**前进**”、“**后退**”操作。这个小项目中简单地演示了如何使用该类。需要提醒的是，iOS系统中，如果app支持 **undo** **redo** 操作，默认是摇晃手势触发。简单的参考<https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/UndoArchitecture/Articles/iPhoneUndo.html>

#### TODO
- 首先是bug。已知的一个bug是，游戏过程中偶尔错误显示。虽然我添加了 **后退** 操作，但并不能固定重现。我打算修改游戏逻辑来绕过去，但这实在是很困扰我，这个bug究竟怎么回事？
- 持久化存储。我希望能添加一个 **save** 操作，保存游戏现场，对游戏有个截图。能给一些开发新手一个参考作用。
- AI.我希望能添加寻路算法，应用于两点。一点是设置游戏难度，目前生成新的数字是随机的地方，如果有AI，设置成困难模式时，这个生成点将是你最不想看到的地方。另一点是自动演示，不过我感觉没什么思路，这个算法该怎么搞？
- 其他。比如支持5*5的游戏区，积分统计之类，不过以我的性格，前两点做完后可能就不会继续维护了。
