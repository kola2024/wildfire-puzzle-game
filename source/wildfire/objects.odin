package fire

import rl "vendor:raylib"

ATLAS_WIDTH :: 2	//
ATLAS_HEIGHT :: 1//

ATLAS_TILE_SIZE :: 16
ats :: ATLAS_TILE_SIZE
Object_Recs := [Object]rl.Rectangle{
    .None = rl.Rectangle{0*ats, 0*ats, ats, ats},
    .Rock = rl.Rectangle{1*ats, 0*ats, ats, ats},
}

init_object_tex :: proc() {

    assert(len(Object) - 1 <= ATLAS_WIDTH * ATLAS_HEIGHT, "u forgot to change atlas!!")

	// atlas :: proc(object: Object, x, y: f32) {
	// 	Object_Recs[object] = {
	// 		(x * ATLAS_TILE_SIZE) + (x), //account for atlas offset
	// 		(y * ATLAS_TILE_SIZE) + (y), //(1 pixel border, gap between texs)
	// 		ATLAS_TILE_SIZE,
	// 		ATLAS_TILE_SIZE,
	// 	}
	// }

	// for i in 1 ..< len(Object) { 	//padded by 1 to remove .empty
	// 	x, y := coords_from_index(i - 1, ATLAS_WIDTH)
	// 	atlas(Object(i), f32(x), f32(y))
	// }
}