//
//  GameScene.swift
//  PopTheLock
//
//  Created by Manoel Pedro Prado Sa Teles on 21/08/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var startingTime = Date.now
    var endingTime = Date.now
    
    var lastEndContact = Date.now
    var lastEndContactTime: Double = 0.0
    
    
    let lockTop = LockTop()
    let lockBase = LockBase()
    let label = Label()
    let labelBg = LabelBackground()
    let player = Player()
    var collectible = Collectible()
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        lockBase.addChild(label)
        lockBase.addChild(labelBg)
        lockBase.addChild(player)
        lockBase.addChild(collectible)
        
        addChild(lockTop)
        addChild(lockBase)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
      
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        player.zPosition += 0.03 * player.velocity
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        print("started contact")
        
        startingTime = Date.now
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        print("ended contact")
        
        lastEndContactTime = Date.now.timeIntervalSince(lastEndContact)
        lastEndContact = Date.now

    }
}
