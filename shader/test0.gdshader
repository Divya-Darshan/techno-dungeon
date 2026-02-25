shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_lambert, specular_disabled;

uniform sampler2D screen_texture : source_color, hint_default_white;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
uniform sampler2D normal_texture : source_color, hint_roughness_r;

uniform vec4 outline_color : source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform float outline_width : hint_range(0.0, 0.01) = 0.002;
uniform float edge_threshold : hint_range(0.0, 0.1) = 0.02;

float get_linear_depth(vec2 uv) {
    float z = texture(DEPTH_TEXTURE, uv).r;
    float near = 0.1; float far = 100.0;
    return (2.0 * near * far) / (far + near - (2.0 * z - 1.0) * (far - near));
}

void vertex() {
    POSITION = vec4(VERTEX.xy, 0.0, 1.0);
}



void fragment() {
    vec2 pixel_size = 1.0 / VIEWPORT_SIZE;
    vec2 offsets[4] = vec2[](
        vec2(-pixel_size.x, 0.0),
        vec2(pixel_size.x, 0.0),
        vec2(0.0, pixel_size.y),
        vec2(0.0, -pixel_size.y)
    );
    
    float center_depth = get_linear_depth(UV);
    float edge = 0.0;
    
    for (int i = 0; i < 4; i++) {
        float sample_depth = get_linear_depth(UV + offsets[i] * outline_width * 1000.0);
        edge = max(edge, abs(sample_depth - center_depth));
    }
    
    edge = 1.0 - smoothstep(0.0, edge_threshold, edge);
    vec3 screen_color = texture(screen_texture, UV).rgb;
    
    ALBEDO = mix(screen_color, outline_color.rgb, edge);
}
