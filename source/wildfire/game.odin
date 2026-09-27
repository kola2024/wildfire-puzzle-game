package fire

import rl "vendor:raylib"
//import "core:fmt"
//import "core:math/linalg"
//import "core:math/rand"

init_world :: proc() -> World {
	w := World {
		run = true,
		state = .main_menu,
		game = {rentex = rl.LoadRenderTexture(RES_W, RES_W)},
		manifest = unmarshal_manifest(),
		resources = {rl.LoadTexture("../../assets/wildfire_atlas.png")},
	}

	rl.SetTextureFilter(w.resources.atlas, .POINT)

	init_object_tex()
	log233332(Object_Recs)
    init_bindings()
    init_main_menu(&w, 0)

    unmarshal_manifest()
	return w
}

update_world :: proc(w: ^World, dt: f32) {
    prev_state := w.state

	w.screen = {rl.GetScreenWidth(), rl.GetScreenHeight()}
    sw, sh := f32(w.screen.x), f32(w.screen.y)
	w.game.size = min(sw, sh)
	w.game.pos = {(sw - w.game.size) / 2, (sh - w.game.size) / 2}

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

	switch w.state {
	case .main_menu:
	case .level_menu:
	case .game:
		update_game(w, dt)
	case .game_menu:
	}

	if prev_state != w.state { 
        clear(&w.buttons)
		log233332("cleared")
	switch w.state {
	case .main_menu:
		init_main_menu(w, dt)

	case .level_menu:
		init_level_menu(w, dt)
	case .game:
		//update_game(w, dt)
	case .game_menu:
	}
}



   
}

init_main_menu :: proc(w: ^World, dt: f32) {
	append(&w.buttons, Button{rl.Rectangle{10, 10, 50, 10}, "Play", false, BA_State{.level_menu}})
	append(&w.buttons, Button{rl.Rectangle{10, 30, 50, 10}, "Quit", false, BA_Exit{}})
}

init_level_menu :: proc(w: ^World, dt: f32) {
	//temp: just one button
	append(&w.buttons, Button{rl.Rectangle{10, 10, 50, 10}, "lvl 1", false, BA_Level{1}})
	append(&w.buttons, Button{rl.Rectangle{10, 30, 50, 10}, "lvl 2", false, BA_Level{2}})
	append(&w.buttons, Button{rl.Rectangle{10, 50, 50, 10}, "lvl 3", false, BA_Level{3}})
}

update_game :: proc(w: ^World, dt: f32) {
	player_velocity := IVec2{0,0}
	if rl.IsKeyPressed(Action[Input.up]) do player_velocity.y -= 1
	else if rl.IsKeyPressed(Action[Input.down]) do player_velocity.y += 1
	else if rl.IsKeyPressed(Action[Input.left]) do player_velocity.x -= 1
	else if rl.IsKeyPressed(Action[Input.right]) do player_velocity.x += 1

	w.level.player.pos += player_velocity
	if player_velocity != {0,0} {
		w.level.time += 1
		update_time(w) //can get rid of level.time in favor of immediate mode, unless we track time for a stat or something/
	}
}

update_time :: proc(w: ^World) {

	grid := w.level.grid
	grid_width := int(w.manifest.levels[w.level_index].size.x)

	for &object in w.level.grid {if object == .Baby_Flame do object = .Flame}
	for &object, index in w.level.grid {
		switch object {
		case .None:
		case .Wheat:
		case .Flame: 
			right := index+1 //note: check bounds
			if right < len(grid) {
				if grid[right] == .Wheat {
					grid[right] = .Baby_Flame
				}
			}
			left := index-1
			if left >= 0 && left / grid_width == index / grid_width {
				if grid[left] == .Wheat {
					grid[left] = .Baby_Flame
				}
			}
			down := index+grid_width
			if down < len(grid) {
				if grid[down] == .Wheat {
					grid[down] = .Baby_Flame
				}
			}
			up := index-grid_width
			if up >= 0 {
				if grid[up] == .Wheat {
					grid[up] = .Baby_Flame
				}
			}
			object = .Ash
		case .Baby_Flame:
		case .Ash:
		}
	}
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
