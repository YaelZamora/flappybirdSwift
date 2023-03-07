//
//  GameScene.swift
//  flappybird
//
//  Created by iOS Maquina 10 on 15/02/23.
//

import SpriteKit
import GameplayKit

enum game
{
    case Ready
    case Inplay
    case GameOver
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var flappy = SKShapeNode()
    var estado = game.Ready
    var flappylabel = SKLabelNode()
    var barras = SKSpriteNode()
    var random1 = GKRandomDistribution(lowestValue: 200, highestValue: 900)
    var random2 = GKRandomDistribution(lowestValue: 150, highestValue: 300)
    var timer = Timer()
    var score = SKLabelNode ()
    var Scoreaux = 0.0
    
    override func didMove(to view: SKView) //Al iniciar la aplicacion, esto pasara
    {
        //self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        backgroundColor = .red
        self.physicsWorld.contactDelegate = self
        barras = SKSpriteNode(color: .green, size: CGSize(width: 20, height: 400))
        score = childNode(withName: "Score") as! SKLabelNode
        barras.anchorPoint = CGPoint(x: 0, y: 0)
        pajarito()
    }
    
    func pajarito()
    {
        flappy = SKShapeNode(circleOfRadius: 10)
        flappylabel.text = "🐥"
        flappylabel.fontSize = 100
        flappylabel.zPosition = 2
        flappylabel.position = CGPoint(x: size.width/2, y: size.width/2)
        addChild(flappylabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)//Al tocar la pantalla
    {
        if estado == .Ready
        {
            flappylabel.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 80, height: 80))
            flappylabel.physicsBody?.isDynamic = true
            flappylabel.physicsBody?.affectedByGravity = true
            flappylabel.physicsBody?.allowsRotation = true
            estado = .Inplay//Comienza el juego
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(barra), userInfo: nil, repeats: true)//Comienza el juego
        }
        flappylabel.physicsBody?.velocity.dy = 650
    }
    
    @objc func barra()//Dimensiones y parametros de las barras
    {
        let primerabarra = random1.nextInt()
        let espacio = random2.nextInt()
        let segundabarra = size.width - CGFloat(primerabarra+espacio)
        let primerabarranodo = barrasnodo(CGFloat(primerabarra))
        let segundabarranodo = barrasnodo(CGFloat(segundabarra))
        
        primerabarranodo.position = CGPoint(x: size.width+20, y: CGFloat(primerabarra/2))
        segundabarranodo.position = CGPoint(x: size.width+20, y: size.height - CGFloat(segundabarra/2))
        addChild(primerabarranodo)
        addChild(segundabarranodo)
    }
    
    func barrasnodo(_ tamanoheight: CGFloat) -> SKShapeNode//Trazado de las barras para la colision
    {
        let tubo = SKShapeNode(rectOf: CGSize(width: 80, height: tamanoheight))
        tubo.fillColor = .green
        tubo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 80, height: tamanoheight))
        tubo.physicsBody?.isDynamic = true
        tubo.physicsBody?.affectedByGravity = false
        tubo.physicsBody?.velocity.dx = -300
        tubo.physicsBody?.contactTestBitMask = 1
        tubo.physicsBody?.collisionBitMask = 1
        tubo.physicsBody?.categoryBitMask = 2
        return tubo
    }
    
    func startgame()//Funcion señuelo para reiniciar el juego
    {
        estado = .Ready
    }
    
    func didBegin(_ contact: SKPhysicsContact)//Al momento de la colision
    {
        timer.invalidate()
        for barradelete in children
        {
            barradelete.removeFromParent()//Borra todo en la pantalla
        }
        
        addChild(score)
        pajarito()
        startgame()//Reinicia el juego
        Scoreaux = 0
        score.text = "Score: \(Scoreaux)"
    }
    
    override func didSimulatePhysics() {
        for node in children
        {
            if node.position.x < -80
            {
                node.removeFromParent()
            }
            if node.position.x <= size.width/2 - 50 && node.position.x >= size.width/2 - 55
            {
                Scoreaux += 0.5
                score.text = "Score: \(Scoreaux)"
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
