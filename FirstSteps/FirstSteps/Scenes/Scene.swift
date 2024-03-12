//
//  Scene.swift
//  FirstSteps
//
//  Created by Ivan Pryhara on 11/03/2024.
//

import MetalKit

class Scene: Node {
    var device: MTLDevice
    var size: CGSize
    
    init(device: MTLDevice, size: CGSize) {
        self.device = device
        self.size = size
        super.init()
    }
    
}
