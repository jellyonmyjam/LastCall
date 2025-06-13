shader_type canvas_item;

uniform float blur_size = 5.0;
uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 color = vec4(0.0);
    float total = 0.0;

    for (float x = -blur_size; x <= blur_size; x++) {
        for (float y = -blur_size; y <= blur_size; y++) {
            vec2 offset = vec2(x, y) / vec2(textureSize(screen_texture, 0));
            color += texture(screen_texture, uv + offset);
            total += 1.0;
        }
    }

    color /= total;
    COLOR = color;
}