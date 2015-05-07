//
//  GameScene.swift
//  MeuSpriteGame
//
//  Created by Orleans Klaus on 07/05/15.
//  Copyright (c) 2015 Orleans Klaus. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // 1 Declarando o jogador
    let player = SKSpriteNode(imageNamed: "jogador")
    
    override func didMoveToView(view: SKView) {
        // 2 Definindo a cor da Cena para azul
        backgroundColor = SKColor.whiteColor()
        // 3 Posicionando o jogador para 10% verticalmente no centro
        player.position = CGPoint(x: size.width * 0.05, y: size.height * 0.5)
        // 4 Adicionando o jogador na Cena
        addChild(player)
        
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
        
        // Create Sprite
        let monster1 = "arvore"
        let monster2 = "noel"
        let monster3 = "palhaco"
        let monster4 = "presente"
        
        for i in 0..<4{
//            let monster = SKSpriteNode(imageNamed: mosnter&&i)
        }
        
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
    }
    

    
}
