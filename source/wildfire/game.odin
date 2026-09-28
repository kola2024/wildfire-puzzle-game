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

	if action_pressed(.fullscreen) do rl.ToggleBorderlessWindowed()

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
				if rl.IsMouseButtonPressed(.LEFT) || action_pressed(.menu_select) {
					switch a in b.action {
					case BA_Exit:
						w.run = false
					case BA_State:
						w.state = a.state
						w.game_menu = false //so dumb
					case BA_Level:
						w.state = .game
						for level, index in w.manifest.levels {
							if a.id == level.id {
								w.level_index = index
								manifest_levelinfo_to_grid(w)
							}
						}
					case BA_Close_Game_Menu:
						close_game_menu(w) //this is kind of dumb. 
					}
				}
				//else logic?
			}
		}
	}

	switch w.state {
	case .main_menu:
		update_main_menu(w, dt)
	case .level_menu:
		update_level_menu(w, dt)
	case .game:
		update_game(w, dt)
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
	}
}

update_main_menu :: proc(w: ^World, dt: f32) {
	if action_pressed(.back) do w.run = false 
}

update_level_menu :: proc(w: ^World, dt: f32) {
	if action_pressed(.back) do w.state = .main_menu
}


}

init_main_menu :: proc(w: ^World, dt: f32) {
	append(&w.buttons, Button{rl.Rectangle{10, 10, 50, 10}, "Play", false, BA_State{.level_menu}})
	append(&w.buttons, Button{rl.Rectangle{10, 30, 50, 10}, "Quit", false, BA_Exit{}})
}

init_level_menu :: proc(w: ^World, dt: f32) {
	//temp: just one button
	//append(&w.buttons, Button{rl.Rectangle{10, 10, 50, 10}, "lvl 1", false, BA_Level{1}})
	//append(&w.buttons, Button{rl.Rectangle{10, 30, 50, 10}, "lvl 2", false, BA_Level{2}})
	//append(&w.buttons, Button{rl.Rectangle{10, 50, 50, 10}, "lvl 3", false, BA_Level{3}})

	level_count := len(w.manifest.levels)
	gaps_count := (level_count*4) - (level_count-1) //a button has 2 "gaps" and a gap between buttons is one gap. nice ratio?
	gaps_size : f32 = 100 / f32(gaps_count) //but this logic is a little messy? it works?
	size_so_far : f32 = gaps_size
	for level in w.manifest.levels {

		append(&w.buttons, Button{rl.Rectangle{10, size_so_far, 50, gaps_size*2}, level.name, false, BA_Level{level.id}})
		size_so_far += gaps_size*3
		log233332(size_so_far)
	}
}

close_game_menu :: proc(w: ^World) {
	w.game_menu = false
	clear(&w.buttons)
}

update_game :: proc(w: ^World, dt: f32) {

	
	if action_pressed(.back) {
		if w.game_menu {
			close_game_menu(w)
		} else {
			w.game_menu = true
			init_game_menu(w)
		}
	}

	if w.game_menu {
		update_game_menu()
		return
	}


	player_velocity := IVec2{0,0}
	if action_pressed(.up) do player_velocity.y -= 1
	else if action_pressed(.down) do player_velocity.y += 1
	else if action_pressed(.left) do player_velocity.x -= 1
	else if action_pressed(.right) do player_velocity.x += 1

	w.level.player.pos += player_velocity
	if player_velocity != {0,0} || action_pressed(.wait) {
		w.level.time += 1
		update_time(w) //can get rid of level.time in favor of immediate mode, unless we track time for a stat or something/
	}

}

init_game_menu :: proc(w: ^World) {
	append(&w.buttons, Button{rl.Rectangle{20, 20, 40, 10}, "Resume", false, BA_Close_Game_Menu{}})
	append(&w.buttons, Button{rl.Rectangle{20, 40, 40, 10}, "Quit", false, BA_State{.level_menu}})
}
update_game_menu :: proc() {}

update_time :: proc(w: ^World) {

	grid := w.level.grid
	grid_width := int(w.manifest.levels[w.level_index].size.x)

	for &object in w.level.grid {
		if object == .Baby_Flame do object = .Flame
		else if object == .Burning_Flower do object = .Baby_Flame
	}
	for &object, index in w.level.grid {
		switch object {
		case .None:
		case .Wheat:
		case .Flame: 
			right := index+1
			if right < len(grid) && right / grid_width == index / grid_width {
				if grid[right] == .Wheat do grid[right] = .Baby_Flame
				else if grid[right] == .Flower do grid[right] = .Burning_Flower
			}
			left := index-1
			if left >= 0 && left / grid_width == index / grid_width {
				if grid[left] == .Wheat do grid[left] = .Baby_Flame
				else if grid[left] == .Flower do grid[left] = .Burning_Flower
			}
			down := index+grid_width
			if down < len(grid) {
				if grid[down] == .Wheat do grid[down] = .Baby_Flame
				else if grid[down] == .Flower do grid[down] = .Burning_Flower
			}
			up := index-grid_width
			if up >= 0 {
				if grid[up] == .Wheat do grid[up] = .Baby_Flame
				else if grid[up] == .Flower do grid[up] = .Burning_Flower
			}
			object = .Ash
		case .Baby_Flame:
		case .Ash:
		case .Burning_Flower:
		case .Flower:
		}
	}
}