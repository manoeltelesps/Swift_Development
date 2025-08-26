//
//  Collectible.swift
//  PopTheLock
//
//  Created by Manoel Pedro Prado Sa Teles on 23/08/25.
//

import SpriteKit

class Collectible: SKSpriteNode {
    
    let spriteRadius: CGFloat!
    let adjustedRadius: CGFloat!
    
    var lastAngle: CGFloat = 270
    var currentAngle: CGFloat = 270
    
    
    init() {
        let texture = SKTexture(imageNamed: "Orange")
        
        spriteRadius = texture.size().width / 2
        adjustedRadius = 200 - 19 - spriteRadius
        
        super.init(texture: texture, color: .white, size: texture.size())
        
        zPosition = 1
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody?.isDynamic = false
        physicsBody?.allowsRotation = false
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = CollisionType.collectible.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        
        setRandomPosition()
    }
    
    func setRandomPosition() {
        lastAngle = currentAngle
        currentAngle = CGFloat.random(in: 0..<360)
        
        let adjustedAngle = currentAngle * .pi / 180
        
        let x = cos(adjustedAngle) * adjustedRadius
        let y = sin(adjustedAngle) * adjustedRadius
        
        position = CGPoint(x: x, y: y)
    }
    
    func setOppositePosition() {
        lastAngle = currentAngle
        currentAngle = 180 + lastAngle
        
        let adjustedAngle = currentAngle * .pi / 180
        
        let x = cos(adjustedAngle) * adjustedRadius
        let y = sin(adjustedAngle) * adjustedRadius
        
        position = CGPoint(x: x, y: y)
    }
    
    func setClosePosition(playerVelocity: CGFloat) {
        lastAngle = currentAngle
        
        let randNextAngle = CGFloat.random(in: 60...180)
        
        if playerVelocity == -1 {
            currentAngle = lastAngle - randNextAngle
        } else {
            currentAngle = lastAngle + randNextAngle
        }
        
        let adjustedAngle = currentAngle * .pi / 180
        
        let x = cos(adjustedAngle) * adjustedRadius
        let y = sin(adjustedAngle) * adjustedRadius
        
        position = CGPoint(x: x, y: y)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
