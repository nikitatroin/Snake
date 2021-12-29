//
//  Created by Никита Троян on 28.12.2021.
//  Copyright © 2021 Pinspb. All rights reserved.
//

import SpriteKit
import GameplayKit


final class GameScene: SKScene {
    var onGameEnd:((Int)->Void)?
    
    /// Наша змея
    var snake: Snake?
    
    /// Яблоко в игре.
    var apple: Apple?
    
    // MARK: - SKScene
    
    override func didMove(to view: SKView) {
        self.configureUI()
        self.configurePhysics()
        self.addButtons()
        self.addSnake()
        self.createApple()
    }
    
    override func update(_ currentTime: TimeInterval) {
        snake?.move()
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //перебераем все точки куда прикоснулся палец
        for touch in touches {
            //определяем координаты касания для точки
            let touchLocation = touch.location(in: self)
            //проверяем есть ли обьект по этим координатам, и если есть, то не наша ли это кнопка
            guard let touchedNode = self.atPoint(touchLocation) as? SKShapeNode
                , touchedNode.name == "counterClockwiseButton" || touchedNode.name == "clockwiseButton" else {
                    return
            }
            //если это наша кнопка заливаем ее зеленой
            touchedNode.fillColor = .green
            // определяем какая кнопка нажата и поворачиваем в нужную сторону
            if touchedNode.name == "counterClockwiseButton" {
                snake?.moveCounterClockwise()
            } else if touchedNode.name == "clockwiseButton" {
                snake?.moveClockwise()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //повторяем все то же самое для действия когда палец отрывается от экрана
        for touch in touches {
            let touchLocation = touch.location(in: self)
            guard let touchedNode = self.atPoint(touchLocation) as? SKShapeNode,
                touchedNode.name == "counterClockwiseButton" || touchedNode.name == "clockwiseButton" else {
                    return
            }
            //но делаем цвет снова серый
            touchedNode.fillColor = UIColor.gray
        }
    }
    
    // MARK: - Private
    
    private func configureUI() {
        backgroundColor = SKColor.black
        //включаем отображение отладочной информации
        self.view?.showsPhysics = true
    }
    
    private func configurePhysics() {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.allowsRotation = false
        //Устанавливаем категорию взаимодействия с другими объектами
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        //устанавливаем категории с которыми будут пересекаться края сцены
        self.physicsBody?.collisionBitMask = CollisionCategories.Snake | CollisionCategories.SnakeHead
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
    }
    
    private func addButtons() {
        guard let view = self.view, let scene = view.scene else { return }
        
        // Поворот против часовой стрелки
        let counterClockwiseButton = SKShapeNode()
        counterClockwiseButton.position = CGPoint(x: scene.frame.minX + 30, y: scene.frame.minY + 30)
        counterClockwiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
        counterClockwiseButton.fillColor = UIColor.gray
        counterClockwiseButton.strokeColor = UIColor.gray
        counterClockwiseButton.lineWidth = 10
        counterClockwiseButton.name = "counterClockwiseButton"
        
        // Поворот по часовой стрелке
        let clockwiseButton = SKShapeNode()
        clockwiseButton.position = CGPoint(x: scene.frame.maxX - 80, y: scene.frame.minY + 30)
        clockwiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
        clockwiseButton.fillColor = UIColor.gray
        clockwiseButton.strokeColor = UIColor.gray
        clockwiseButton.lineWidth = 10
        clockwiseButton.name = "clockwiseButton"
        
        self.addChild(counterClockwiseButton)
        self.addChild(clockwiseButton)
    }
    
    private func addSnake() {
        guard let view = self.view, let scene = view.scene else { return }
        
        //создаем змею по центру экрана и добавляем ее на сцену
        let snake = Snake(atPoint: CGPoint(x: scene.frame.midX, y: scene.frame.midY))
        self.snake = snake
        self.addChild(snake)
    }
    
    private func createApple() {
        guard let view = self.view, let scene = view.scene else { return }
        let randX  = CGFloat(arc4random_uniform(UInt32(scene.frame.maxX - 5)) + 1)
        let randY  = CGFloat(arc4random_uniform(UInt32(scene.frame.maxY - 5)) + 1)
        let apple = Apple(position: CGPoint(x: randX, y: randY))
        self.apple = apple
        self.addChild(apple)
    }
    
    private func restartGame() {
        self.snake?.body.forEach { $0.removeFromParent() }
        self.snake?.removeFromParent()
        self.snake = nil
        self.apple?.removeFromParent()
        self.apple = nil
        self.addSnake()
        self.createApple()
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        //логическая сумма масок соприкоснувшихся объектов
        let bodyes = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        //вычитаем из суммы голову змеи и у нас остается маска второго объекта
        let collisionObject = bodyes ^ CollisionCategories.SnakeHead
        
        //проверяем что это за второй объект
        switch collisionObject {
        case CollisionCategories.Apple: //проверяем что это яблоко
            //яблоко это один из двух объектов, используем тернарный оператор чтобы вычислить какой
            let apple = contact.bodyA.node is Apple ? contact.bodyA.node : contact.bodyB.node
            self.headDidCollideApple(apple: apple)
        case CollisionCategories.EdgeBody: //проверяем что это стенка экрана
            self.headDidCollideWall(contact)
        default:
            break
        }
    }
    
    private func headDidCollideApple(apple: SKNode?) {
        //добавляем к змее еще одну секцию
        snake?.addBodyPart()
        //удаляем яблоко
        apple?.removeFromParent()
        self.apple = nil
        //создаем новое яблоко
        createApple()
    }
    
    private func headDidCollideWall(_ contact: SKPhysicsContact) {
        guard let snake = self.snake else { return }
        let score = snake.body.count - 1
        self.onGameEnd?(score)
        let record = Records(score: score, date: Date())
        Game.shared.add(record)
        self.restartGame()
    }
}


