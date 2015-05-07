//
//  GameScene.swift
//  MeuSpriteGame
//
//  Created by Orleans Klaus on 07/05/15.
//  Copyright (c) 2015 Orleans Klaus. All rights reserved.
//

import SpriteKit
import AVFoundation

var backgroundMusicPlayer: AVAudioPlayer!
// Adicionando alguma música de fundo
func playBackgroundMusic(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(
        filename, withExtension: nil)
    if (url == nil) {
        println("Could not find file: \(filename)")
        return
    }
    var error: NSError? = nil
    backgroundMusicPlayer =
        AVAudioPlayer(contentsOfURL: url, error: &error)
    if backgroundMusicPlayer == nil {
        println("Could not create audio player: \(error!)")
        return
    }
    backgroundMusicPlayer.numberOfLoops = -1
    backgroundMusicPlayer.prepareToPlay()
    backgroundMusicPlayer.play()
}
// Funcões matemáticas para controlar a direcao dos tiros
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // 1 Declarando o jogador
    let player = SKSpriteNode(imageNamed: "jogador")
    
    override func didMoveToView(view: SKView) {
        // 2 Definindo a cor da Cena para azul
        backgroundColor = SKColor.whiteColor()
        // 3 Posicionando o jogador para 10% verticalmente no centro
        player.position = CGPoint(x: size.width * 0.05, y: size.height * 0.5)
        // 4 Adicionando o jogador na Cena
        addChild(player)
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        addMonster()
        
        // Adicionando musica no jogo
        playBackgroundMusic("background-music-aac.caf")
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
            SKAction.runBlock(addMonster),
            SKAction.waitForDuration(1.0)])
                ))
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster() {
        
        // Crio um array de monstros
        
        let monstros = ["arvore", "noel", "palhaco", "presente"]
        
        for (index, object) in enumerate(monstros) {
            // Create sprite
            let monster = SKSpriteNode(imageNamed:(object))
            
            // Determina onde para o Sprite ao longo do eixo Y
            let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
            
            // Posição do monstro ligeiramente fora da tela ao longo da borda direita,
            // E ao longo de uma posição aleatória ao longo do eixo Y como calculado acima
            monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
            
            // Adiciona o monstro na Cena
            addChild(monster)
            
            // Determina a velocidade do monstro
            let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
            
            // Cria as açoes
            let actionMove = SKAction.moveTo(CGPoint(x: -monster.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))// direcionar o objeto se mover para fora da tela
            let actionMoveDone = SKAction.removeFromParent()// remover o monstro da cena quando ela não é mais visível
            monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))// encadear uma seqüência de ações que são executadas em ordem, uma de cada vez

            monster.physicsBody = SKPhysicsBody(rectangleOfSize: monster.size) // 1 Cria um corpo de física para o sprite.
            monster.physicsBody?.dynamic = true // 2 Define o sprite para ser dinâmico.
            monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster // 3 Define a máscara categoria pouco para ser o monsterCategory você definiu anteriormente.
            monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile // 4  Quais as categorias de objetos desse objeto deve notificar o ouvinte contato quando eles se cruzam.
            monster.physicsBody?.collisionBitMask = PhysicsCategory.None // 5 Quais as categorias de objetos este objeto que o motor de física respostas contacto alça para (ou seja, saltar fora de).
            
        }
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        // 1 - Escolha um dos toques iniciais para trabalhar
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        
        // 2 - Configura a localização inicial do projétil
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = player.position
        
        // 3 - Determinar o deslocamento de localização de projétil
        let offset = touchLocation - projectile.position
        
        // 4 - Saida da bola se você está atirando para baixo ou para trás
        if (offset.x < 0) { return }
        
        // 5 - Adicionar o bola - posição que você dobro verificado
        addChild(projectile)
        
        // 6 - Obter a direção de onde disparar
        let direction = offset.normalized()
        
        // 7 - Faça-lhe atirar longe o suficiente para ser garantida fora da tela
        let shootAmount = direction * 1000
        
        // 8 - Adicionar a quantidade atirar para a posição atual
        let realDest = shootAmount + projectile.position
        
        // 9 - Criar as ações
        let actionMove = SKAction.moveTo(realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
        // Trata o Projeto para ser lançado nos monstros
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.dynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        // Quando acerta o alvo, toca outra musica
        runAction(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
        
    }
    
    // método será chamado sempre que dois corpos colidem físicamente
    func didBeginContact(contact: SKPhysicsContact) {
        
        // 1 Esse método passa os dois corpos que se chocam, mas não garante que eles são passados ​​em qualquer ordem particular.
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2 erifica para ver se os dois corpos que se chocam são o projétil e monstro, e se assim chama o método
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
                projectileDidCollideWithMonster(firstBody.node as! SKSpriteNode, monster: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    // Método que será chamado quando o projétil colide com o monstro.
    func projectileDidCollideWithMonster(projectile:SKSpriteNode, monster:SKSpriteNode) {
        println("Hit")
        projectile.removeFromParent()
        monster.removeFromParent()
    }
    
    // Define a estrutura de categorias
    struct PhysicsCategory {
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let Monster   : UInt32 = 0b1       // 1
        static let Projectile: UInt32 = 0b10      // 2
    }
}
