package fire

import rl "vendor:raylib"
//import "core:fmt"
//import "core:math"
//import "core:math/linalg"
//import "core:math/rand"

init_world :: proc() -> World {
	w := World {
		run = true,
		state = .main_menu,
        prev_state = .game, //anything else
		game = {rentex = rl.LoadRenderTexture(RES_W, RES_W)},
	}

    init_bindings()
    update_main_menu(&w, 0)
	return w
}

update_world :: proc(w: ^World, dt: f32) {
    log233332(w.buttons[:])
    prev_state := w.state

    sw, sh := f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())
	w.game.size = min(sw, sh)
	w.game.pos = {(sw - w.game.size) / 2, (sh - w.game.size) / 2}
	w.screen = {rl.GetScreenWidth(), rl.GetScreenHeight()}

	w.last_mouse_pos = w.mouse
	w.mouse = rl.GetMousePosition()
	w.mouse_game = screen_to_game(w, w.mouse)

	if len(w.buttons) > 0 {
		check_input_mode(w)
		check_buttons_active(w)
		for &b in w.buttons {
			if b.active {
				if rl.IsMouseButtonPressed(.LEFT) || rl.IsKeyPressed(Action[Input.menu_select]) do b.action(w)
				//else logic?
			}
		}
	}


	if prev_state != w.state { 
        clear(&w.buttons) //NOTE: inefficient! could clear every switch instead (also here do a rest for w.buttons_index)
	switch w.state {
	case .main_menu:
		update_main_menu(w, dt)

	case .level_menu:
		update_level_menu(w, dt)
	case .game, .game_menu:
	}
}



   
}

update_main_menu :: proc(w: ^World, dt: f32) {
	append(&w.buttons, Button{rl.Rectangle{10, 10, 50, 10}, "Play", false, forward})
	append(&w.buttons, Button{rl.Rectangle{10, 30, 50, 10}, "Quit", false, back})
}

update_level_menu :: proc(w: ^World, dt: f32) {
	//temp: just one button
	append(&w.buttons, Button{rl.Rectangle{10, 50, 50, 10}, "lvl 1", false, forward})
}

back :: proc(w: ^World) {
	switch w.state {
	case .main_menu:
		w.run = false
	case .level_menu:
        w.state = .main_menu
	case .game:
        w.state = .level_menu
	case .game_menu:
        w.state = .game
	}
}

forward :: proc(w: ^World) {
	switch w.state {
	case .main_menu:
		w.state = .level_menu
	case .level_menu:
		w.state = .game
	case .game:
        w.state = .game_menu
	case .game_menu:
	}
}
