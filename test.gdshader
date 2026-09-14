shader_type canvas_item;
instance uniform float brightness = 1;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR *= vec4(brightness, brightness, brightness, 1);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
