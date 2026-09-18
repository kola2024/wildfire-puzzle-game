package fire

import rl "vendor:raylib"
//import "core:fmt"
//import "core:math"
//import "core:math/linalg"
//import "core:math/rand"

RES_W :: 100

draw_world :: proc(w: ^World) {
    rl.BeginDrawing()
	rl.ClearBackground({20, 20, 20, 255})
    rl.BeginTextureMode(w.game.rentex)
    rl.ClearBackground(rl.BLACK)
    rl.EndTextureMode()
    src := rl.Rectangle{0, 0, w.game.size, -w.game.size}
    dst := rl.Rectangle{w.game.pos.x, w.game.pos.y, w.game.size, w.game.size}
    rl.DrawTexturePro(w.game.rentex.texture, src, dst, {0,0}, 0, rl.WHITE)
}