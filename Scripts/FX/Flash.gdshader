shader_type canvas_item;

uniform bool active = false;
uniform vec4 color : hint_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 sprite_color = vec4(color.r, color.g, color.b, previous_color.a);
	vec4 new_color = previous_color;
	if (active == true)
	{
		new_color = sprite_color
	}
	COLOR = new_color;
}