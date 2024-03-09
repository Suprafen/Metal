//
//  Shader.metal
//  FirstSteps
//
//  Created by Ivan Pryhara on 09/03/2024.
//

#include <metal_stdlib>
using namespace metal;
//vertex function
vertex float4 vertex_shader(const device packed_float3 *vertices [[ buffer(0) ]],
                            uint vertexId [[ vertex_id ]]) {
    return float4(vertices[vertexId], 1);
}
// fragment function which returns half4(smaller float form)
fragment half4 fragment_shader() {
    // returning a color (r, g, b, a)
    return half4(1, 0, 0, 1);
}
