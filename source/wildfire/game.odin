package fire

import rl "vendor:raylib"
import "core:fmt"
//import "core:math"
//import "core:math/linalg"
//import "core:math/rand"

init_world :: proc() -> World {
    w := World{
        run = true,
        state = .main_menu,
        game = {rentex = rl.LoadRenderTexture(RES_W, RES_W)},
    }
    return w
}

update_world :: proc(w: ^World, dt: f32) {
    clear(&w.buttons) //NOTE: inefficient! could clear every switch instead
    switch w.state {
    case .main_menu:
        update_main_menu(w, dt)

    case .level_menu, .game, .game_menu:
    }

    for &b in w.buttons {
        if check_button_active(w, &b) {b.action(w)}
    }

    sw, sh := f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())
    w.game.size = min(sw, sh)
    w.game.pos = {(sw - w.game.size) / 2, (sh - w.game.size) / 2}
    w.screen = {rl.GetScreenWidth(), rl.GetScreenHeight()}

    w.mouse = rl.GetMousePosition()
    w.mouse_game = screen_to_game(w, w.mouse)

    w.cam = rl.Camera2D{
        offset = w.game.pos,
        zoom = w.game.size / RES_W,
        target = {0,0},
    }
}

update_main_menu :: proc(w: ^World, dt: f32) {
    append(&w.buttons, Button{rl.Rectangle{10, 10, 50, 10},"Play", false, forward})
    append(&w.buttons, Button{rl.Rectangle{10, 30, 50, 10},"Quit", false, back})


}

back :: proc(w: ^World) {
    switch w.state {
    case .main_menu:
        w.run = false
    case .level_menu:
    case .game:
    case .game_menu:
    }
}

forward :: proc(w: ^World) {
    switch w.state {
    case .main_menu:
        fmt.println("forwards!")
    case .level_menu:
    case .game:
    case .game_menu:
    }
}