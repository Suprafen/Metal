//
//  GameScene.swift
//  FirstSteps
//
//  Created by Ivan Pryhara on 11/03/2024.
//

import MetalKit

class GameScene: Scene {
    var quad: Plane
    
    override init(device: MTLDevice, size: CGSize) {
        quad = Plane(device: device)
        super.init(device: device, size: size)
        
        add(childNode: quad)
    }
}
