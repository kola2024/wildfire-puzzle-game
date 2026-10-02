package fire

import rl "vendor:raylib"

Object :: enum u8 {
    None,
    Wheat,
	Flame,
	Flame_Small,
	Flame_Tiny,
	Ash,
	Flower,
	Burning_Flower,
	Star,
}

rune_to_object :: proc(r: rune) -> Object {
	switch r {
	case ' ': return .None
	case 'w': return .Wheat
	case 'F': return .Flame_Tiny
	case 'f': return .Flame_Tiny
	case 'a': return .Ash
	case 'B': return .Flower
	case 'b': return .Burning_Flower
	case '*': return .Star
	}
	return .None
}
ATLAS_WIDTH :: 4
ATLAS_HEIGHT :: 3
#assert(len(Object) - 1 < ATLAS_WIDTH * ATLAS_HEIGHT, "u forgot to change atlas!!")

ATLAS_TILE_SIZE :: 16

Object_Recs : [Object]rl.Rectangle

init_object_tex :: proc() {

	atlas_rec :: proc(index: int) -> rl.Rectangle {
		return rl.Rectangle{f32(index % ATLAS_WIDTH) * ATLAS_TILE_SIZE, f32(index / ATLAS_WIDTH) * ATLAS_TILE_SIZE, ATLAS_TILE_SIZE, ATLAS_TILE_SIZE}
	}

	Object_Recs = [Object]rl.Rectangle{
    	.None = atlas_rec(0),
    	.Wheat = atlas_rec(1),
		.Flame = atlas_rec(7),
		.Flame_Small = atlas_rec(6),
		.Flame_Tiny = atlas_rec(2),
		.Ash = atlas_rec(3),
		.Flower = atlas_rec(4),
		.Burning_Flower = atlas_rec(5),
		.Star = atlas_rec(8),
	}
}