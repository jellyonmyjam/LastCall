shader_type canvas_item;

uniform float fill_amount : hint_range(0.0, 1.0) = 0.0; // From 0 (empty) to 1 (full)
uniform vec4 tint_color : source_color = vec4(1.0);
uniform float curve_height : hint_range(0.0, 0.1) = 1; // Height of the curve at the edges

void fragment() {
    // Create a parabola centered at UV.x = 0.5, value increases toward edges
    float curve = pow((UV.x - 0.5) * 2.0, 2.0) * curve_height * 5.0;

    // Discard pixels above the curved fill level
    if (UV.y < 1.0 - fill_amount + curve) {
        discard;
    }

    COLOR = texture(TEXTURE, UV) * tint_color;
}