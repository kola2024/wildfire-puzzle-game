package fire

import "core:fmt"
import "core:math/linalg"

log233332 :: proc(args: ..any) {
    fmt.println(args)
}

screen_to_game :: proc(w: ^World, vec: Vec2) -> Vec2 {
    scale := w.game.size / RES_W
    inv := 1 / scale
    t := linalg.Matrix3x3f32{
        inv, 0, -w.game.pos.x * inv, //note: scale this
        0, inv, -w.game.pos.y * inv,
        0, 0, 1,
    }
    res := t * Vec3{vec.x, vec.y, 1}
    //return Vec2{res.x, res.y}
    return res.xy //SWIZZLE!
}

coords_from_index :: proc(index: int, width: i32) -> (IVec2) {
	x := i32(index) % i32(width)
	y := i32(index) / i32(width)
	return {x, y}
}

index_from_coords :: proc(x, y, width: i32) -> i32 {
	return (y * width) + x
}