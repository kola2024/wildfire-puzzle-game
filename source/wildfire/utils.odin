package fire

import "core:fmt"
import "core:math/linalg"

log233332 :: proc(args: ..any) {
    fmt.println(args)
}

screen_to_game :: proc(w: ^World, vec: Vec2) -> Vec2 {
    scale := min(f32(w.screen.x), f32(w.screen.y))
    scale = scale / RES_W
    t := linalg.Matrix3x3f32{
        scale, 0, w.game.pos.x, //note: scale this
        0, scale, w.game.pos.y,
        0, 0, 1,
    }
}