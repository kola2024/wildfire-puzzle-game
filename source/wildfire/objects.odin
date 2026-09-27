package fire

import rl "vendor:raylib"

Object :: enum u8 {
    None,
    Wheat,
	Flame,
	Baby_Flame,
	Ash,
}

rune_to_object :: proc(r: rune) -> Object {
	switch r {
	case ' ': return .None
	case 'w': return .Wheat
	case 'F': return .Flame
	case 'f': return .Baby_Flame
	case 'a': return .Ash
	}
	return .None
}
ATLAS_WIDTH :: 4	//
ATLAS_HEIGHT :: 1//

ATLAS_TILE_SIZE :: 16

Object_Recs : [Object]rl.Rectangle

init_object_tex :: proc() {

    assert(len(Object) - 1 <= ATLAS_WIDTH * ATLAS_HEIGHT, "u forgot to change atlas!!")

	atlas_rec :: proc(index: int) -> rl.Rectangle {
		return rl.Rectangle{f32(index % ATLAS_WIDTH) * ATLAS_TILE_SIZE, f32(index / ATLAS_WIDTH) * ATLAS_TILE_SIZE, ATLAS_TILE_SIZE, ATLAS_TILE_SIZE}
	}

	Object_Recs = [Object]rl.Rectangle{
    	.None = atlas_rec(0),
    	.Wheat = atlas_rec(1),
		.Flame = atlas_rec(2),
		.Baby_Flame = atlas_rec(2),
		.Ash = atlas_rec(3),
	}
}