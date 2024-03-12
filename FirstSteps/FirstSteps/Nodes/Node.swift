//
//  Node.swift
//  FirstSteps
//
//  Created by Ivan Pryhara on 11/03/2024.
//

import MetalKit

class Node {
    var name: String = "Untitled"
    var children: [Node] = []
    
    func add(childNode: Node) {
        children.append(childNode)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder,
                deltaTime: Float) {
        for child in children {
            child.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        }
    }
}
