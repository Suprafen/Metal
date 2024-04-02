//
//  Texturable.swift
//  FirstSteps
//
//  Created by Ivan Pryhara on 02/04/2024.
//

import MetalKit

protocol Texturable {
    var texture: MTLTexture? { get set }
}

extension Texturable {
    func setTexture(device: MTLDevice, imageName: String) -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: device)
        
        var texture: MTLTexture? = nil
        
        let textureOptions: [MTKTextureLoader.Option : NSObject]
        
        let origin = NSString(string: MTKTextureLoader.Origin.bottomLeft.rawValue)
        
        textureOptions = [MTKTextureLoader.Option.origin : origin]
    
        
        if let textureURL = Bundle.main.url(forResource: imageName, withExtension: nil) {
            do {
                texture = try textureLoader.newTexture(URL: textureURL, options: textureOptions)
            } catch {
                print("Failed to load texture")
            }
        }
        
        return texture
    }
}
