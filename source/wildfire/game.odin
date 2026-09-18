package fire

import rl "vendor:raylib"
//import "core:fmt"
//import "core:math"
//import "core:math/linalg"
//import "core:math/rand"

init_world :: proc() -> World {
    w := World{
        state = .main_menu,
    }
    return w
}

update_world :: proc(w: ^World, dt: f32) {
switch w.state {
    case .main_menu:
        update_main_menu(w, dt)

    case .level_menu, .game, .game_menu:
}

screen := IVec2{rl.GetScreenWidth(), rl.GetScreenHeight()}
ratio := screen.x / screen.y
w.game.rect = rl.Rectangle{}
}

update_main_menu :: proc(w: ^World, dt: f32) {
    
}