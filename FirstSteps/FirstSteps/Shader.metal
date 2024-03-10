//
//  Shader.metal
//  FirstSteps
//
//  Created by Ivan Pryhara on 09/03/2024.
//

#include <metal_stdlib>
using namespace metal;

struct Constants {
    float animateBy;
};

//vertex function
vertex float4 vertex_shader(const device packed_float3 *vertices [[ buffer(0) ]],
                            constant Constants &constants [[buffer(1)]],
                            uint vertexId [[ vertex_id ]]) {
    
    float4 position = float4(vertices[vertexId], 1);
    position.x += constants.animateBy;
    
    return position;
}
// fragment function which returns half4(smaller float form)
fragment half4 fragment_shader(constant float &color [[buffer(2)]]) {
    // returning a color (r, g, b, a)
    return half4(1, color, 0, 1);
}
