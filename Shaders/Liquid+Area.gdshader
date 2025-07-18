shader_type canvas_item;

uniform vec2 boundary_min;
uniform vec2 boundary_max;
uniform float fill_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec4 tint_color : source_color = vec4(1.0);
uniform float curve_height : hint_range(0.0, 0.1) = 0.02;

void fragment() {
    // Boundary-based panel clipping
    if (FRAGCOORD.x < boundary_min.x || FRAGCOORD.x > boundary_max.x ||
        FRAGCOORD.y < boundary_min.y || FRAGCOORD.y > boundary_max.y) {
        discard;
    }

    // Curved liquid fill masking
    float curve = pow((UV.x - 0.5) * 2.0, 2.0) * curve_height * 5.0;

    if (UV.y < 1.0 - fill_amount + curve) {
        discard;
    }

    COLOR = texture(TEXTURE, UV) * tint_color;
}