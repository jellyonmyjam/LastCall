shader_type canvas_item;

uniform vec2 boundary_min;
uniform vec2 boundary_max;
uniform vec4 tint_color: source_color = vec4(1.0);

void fragment() {
    // Check if the current fragment is outside the clipping area
    if (FRAGCOORD.x < boundary_min.x || FRAGCOORD.x > boundary_max.x ||
        FRAGCOORD.y < boundary_min.y || FRAGCOORD.y > boundary_max.y) {
        discard; // Hide the fragment if outside the area
    }
    COLOR = texture(TEXTURE, UV) * tint_color; // Otherwise, display the texture as usual
}