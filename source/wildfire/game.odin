package fire

import rl "vendor:raylib"
//import "core:fmt"
//import "core:math"
//import "core:math/linalg"
//import "core:math/rand"

init_world :: proc() -> World {
    w := World{
        state = .main_menu,
        game = {rentex = rl.LoadRenderTexture(RES_W, RES_W)},
    }
    return w
}

update_world :: proc(w: ^World, dt: f32) {
switch w.state {
case .main_menu:
    update_main_menu(w, dt)

case .level_menu, .game, .game_menu:
}
sw, sh := f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())
w.game.size = min(sw, sh)

w.game.pos = {(sw - w.game.size) / 2, (sh - w.game.size) / 2}
}

update_main_menu :: proc(w: ^World, dt: f32) {
    
}