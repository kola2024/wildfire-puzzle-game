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
		game = {rentex = rl.LoadRenderTexture(RES_W, RES_W)},
		manifest = unmarshal_manifest(),
	}

    init_bindings()
    update_main_menu(&w, 0)

    unmarshal_manifest()
	return w
}

update_world :: proc(w: ^World, dt: f32) {
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
				if rl.IsMouseButtonPressed(.LEFT) || rl.IsKeyPressed(Action[Input.menu_select]) {
					switch a in b.action {
					case BA_Exit:
						w.run = false
					case BA_State:
						w.state = a.state
					case BA_Level:
						w.state = .game
						for level, index in w.manifest.levels {
							if a.id == level.id {
								w.level_index = index
								manifest_levelinfo_to_grid(w)
							}
						}
					}
				}
				//else logic?
			}
		}
	}


	if prev_state != w.state { 
        clear(&w.buttons)
		log233332("cleared")
	switch w.state {
	case .main_menu:
		update_main_menu(w, dt)

	case .level_menu:
		update_level_menu(w, dt)
	case .game:
		update_game(w, dt)
	case .game_menu:
	}
}



   
}

update_main_menu :: proc(w: ^World, dt: f32) {
	append(&w.buttons, Button{rl.Rectangle{10, 10, 50, 10}, "Play", false, BA_State{.level_menu}})
	append(&w.buttons, Button{rl.Rectangle{10, 30, 50, 10}, "Quit", false, BA_Exit{}})
}

update_level_menu :: proc(w: ^World, dt: f32) {
	//temp: just one button
	append(&w.buttons, Button{rl.Rectangle{10, 50, 50, 10}, "lvl 1", false, BA_Level{1}})
}

update_game :: proc(w: ^World, dt: f32) {
	
}

level :: proc(w: ^World) {

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
		//w.state = .game
	case .game:
        w.state = .game_menu
	case .game_menu:
	}
}
