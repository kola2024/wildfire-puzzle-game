package fire

import rl "vendor:raylib"

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
				if rl.IsMouseButtonPressed(.LEFT) || action_pressed(.menu_select) { //@MOUSE
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
					case BA_Nothing:
					}
				}
			}
		}
	}

	//update based on state
	switch w.state {
	case .main_menu:
		update_main_menu(w, dt)
	case .level_menu:
		update_level_menu(w, dt)
	case .game:
		update_game(w, dt)
	}

	//initialize based on state (on a per switch basis)
	if prev_state != w.state { 
        clear(&w.buttons)
	switch w.state {
	case .main_menu:
		init_main_menu(w, dt)
	case .level_menu:
		init_level_menu(w, dt)
	case .game:
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
		//update_game_menu()
		return
	}

		//player update
	grid_width := w.manifest.levels[w.level_index].size.x
	grid_height := w.manifest.levels[w.level_index].size.y

	//player lose/level state check (right now in a placeholder.. kind of..)
	lose :: proc(w: ^World) {
		w.game_menu = true
		init_game_menu(w)
		append(&w.buttons, Button{rl.Rectangle{27, 2, 40, 10}, "You Lose!", false, BA_Nothing{}})
	}
	player_index_pos := index_from_coords(w.level.player.pos.x, w.level.player.pos.y, grid_width)
	player_grid_pos := w.level.grid[player_index_pos]
	if player_grid_pos == .Flame_Tiny || player_grid_pos == .Flame_Small || player_grid_pos == .Flame {
		 lose(w)
		 return
	}

	//player movement
	player_velocity := IVec2{0,0}
	if action_pressed(.up) do player_velocity.y -= 1
	else if action_pressed(.down) do player_velocity.y += 1
	else if action_pressed(.left) do player_velocity.x -= 1
	else if action_pressed(.right) do player_velocity.x += 1

	new_player_pos := w.level.player.pos + player_velocity
	new_player_index_pos := index_from_coords(new_player_pos.x, new_player_pos.y, grid_width)
	
	//bounds check
	if new_player_pos.x < 0 || new_player_pos.x > grid_width-1 do return
	if new_player_pos.y < 0 || new_player_pos.y > grid_height-1 do return
	//object collision check (for walls and such, no interpolation)
	if w.level.grid[new_player_index_pos] == .Ash do return

	w.level.player.pos = new_player_pos

	if player_velocity != {0,0} || action_pressed(.wait) {
		w.level.time += 1
		update_time(w) //can get rid of level.time in favor of immediate mode, unless we track time for a stat or something/
	}

}

init_game_menu :: proc(w: ^World) {
	append(&w.buttons, Button{rl.Rectangle{20, 20, 40, 10}, "Resume", false, BA_Close_Game_Menu{}})
	append(&w.buttons, Button{rl.Rectangle{20, 40, 40, 10}, "Quit", false, BA_State{.level_menu}})
}
//update_game_menu :: proc() {}

update_time :: proc(w: ^World) {

	grid := w.level.grid
	grid_width := int(w.manifest.levels[w.level_index].size.x)

	for &object in w.level.grid {
		if object == .Flame do object = .Ash
		if object == .Flame_Small do object = .Flame //has to be before other
		if object == .Flame_Tiny do object = .Flame_Small
		else if object == .Burning_Flower do object = .Flame_Tiny
	}
	for &object, index in w.level.grid {
		switch object {
		case .None:
		case .Wheat:
		case .Flame_Small: 
			right := index+1
			if right < len(grid) && right / grid_width == index / grid_width {
				if grid[right] == .Wheat do grid[right] = .Flame_Tiny
				else if grid[right] == .Flower do grid[right] = .Burning_Flower
			}
			left := index-1
			if left >= 0 && left / grid_width == index / grid_width {
				if grid[left] == .Wheat do grid[left] = .Flame_Tiny
				else if grid[left] == .Flower do grid[left] = .Burning_Flower
			}
			down := index+grid_width
			if down < len(grid) {
				if grid[down] == .Wheat do grid[down] = .Flame_Tiny
				else if grid[down] == .Flower do grid[down] = .Burning_Flower
			}
			up := index-grid_width
			if up >= 0 {
				if grid[up] == .Wheat do grid[up] = .Flame_Tiny
				else if grid[up] == .Flower do grid[up] = .Burning_Flower
			}
		case .Flame_Tiny:
		case .Flame:
		case .Ash:
		case .Burning_Flower:
		case .Flower:
		case .Star:
		}
	}
}