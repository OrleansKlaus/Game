//
//  GameOverScene.swift
//  MeuSpriteGame
//
//  Created by Orleans Klaus on 07/05/15.
//  Copyright (c) 2015 Orleans Klaus. All rights reserved.
//

import Foundation

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, won:Bool) {
        
        super.init(size: size)
        
        // 1 Define a cor de fundo para branco, mesmo que você fez para a cena principal.
        backgroundColor = SKColor.whiteColor()
        
        // 2 Com base na won parâmetro, define a mensagem para qualquer um "You Won" ou "você perde".

        var message = won ? "Você Ganhou!" : "Você Perdeu:["
        
        // 3 Isto é como você exibir um rótulo de texto para a tela com Kit Sprite. Como você pode ver, é muito fácil - você só escolher o seu tipo de letra e definir alguns parâmetros.

        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        // 4 Finalmente, este configura e executa uma seqüência de duas ações. Eu incluí-los todos em linha aqui para mostrar-lhe como útil que é (em vez de ter que fazer variáveis ​​separadas para cada ação). Primeiro ele aguarda por 3 segundos, em seguida, ele usa o runBlock ação para executar um código arbitrário.

        runAction(SKAction.sequence([
            SKAction.waitForDuration(3.0),
            SKAction.runBlock() {
                // 5 Isto é como você fazer a transição para uma nova cena no Kit Sprite. Primeiro você pode escolher entre uma variedade de diferentes transições animadas para como você quer as cenas para mostrar - você escolhe uma transição aleta aqui que leva 0,5 segundo. Em seguida, você criar a cena que você deseja exibir e usar o presentScene(_:transition:) método no self.view propriedade.

                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
        
    }
    
    // 6 Se você substituir um inicializador em uma cena, você deve implementar a necessária init(coder:) inicializador também. No entanto, este inicializador nunca será chamado, então você apenas adicionar uma implementação fictícia com um fatalError(_:) por enquanto.
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}