package fire

import rl "vendor:raylib"



check_buttons_active :: proc(w: ^World) {
    assert(len(w.buttons) > 0, "buttons is 0")
	if !w.keyboard_input {
		for &button in w.buttons {
			button.active = rl.CheckCollisionPointRec(w.mouse_game, button.rect)
		}
	} else {
		if rl.IsKeyPressed(Action[Input.menu_down]) do w.button_index += 1
		if rl.IsKeyPressed(Action[Input.menu_up]) do w.button_index -= 1
		idx := w.button_index % u8(len(w.buttons))
        w.buttons[idx].active = true
	}
}

check_button_state :: proc() {

}

check_input_mode :: proc(w: ^World) {
    if w.keyboard_input {
        w.keyboard_input = !mouse_moved(w)
    } else {
        if rl.IsKeyPressed(Action[Input.menu_up]) || rl.IsKeyPressed(Action[Input.menu_down]) do w.keyboard_input = true
    }
}

mouse_moved :: proc(w: ^World) -> bool {
    return w.mouse != w.last_mouse_pos
}