#+feature dynamic-literals
package fire

import rl "vendor:raylib"

Input :: enum i32 {
	menu_up,
	menu_down,
    menu_select,

	up,
	down,
	left,
	right,
	wait,
}

max_binds :: 3

Action := [Input][max_binds]rl.KeyboardKey{} //pedantic btu should be input instead of Input

init_bindings :: proc() {
	// Action[Input.menu_up] = .UP
	// Action[Input.menu_down] = .DOWN
	// Action[Input.menu_select] = .ENTER
	// Action[Input.up] = .W
	// Action[Input.down] = .S
	// Action[Input.left] = .A
	// Action[Input.right] = .D
	// Action[Input.wait] = .SPACE
	bind(.menu_up, .W) ; bind(.menu_up, .UP)
	bind(.menu_down, .S) ; bind(.menu_down, .DOWN)
	bind(.menu_select, .ENTER) ; bind(.menu_select, .SPACE)
	bind(.up, .W) ; bind(.up, .UP)
	bind(.down, .S) ; bind(.down, .DOWN)
	bind(.left, .A) ; bind(.left, .LEFT)
	bind(.right, .D) ; bind(.right, .RIGHT)
	bind(.wait, .ENTER) ; bind(.wait, .SPACE)
	log233332(Action[.wait])
}
bind :: proc{bind_index, bind_null}
bind_index :: proc(input: Input, index: int, key: rl.KeyboardKey) {
	Action[input][index] = key
}

bind_null :: proc(input: Input, key: rl.KeyboardKey) {
	for &setkey in Action[input] {
		if setkey == .KEY_NULL {
			setkey = key
			return
		}
	}
}

action_pressed :: proc(input: Input) -> bool {
	for key in Action[input] {
		if key != .KEY_NULL && rl.IsKeyPressed(key) {
			return true
		}
	}
	return false
}



//accessed via e.g. rl.IsKeyPressed(Action[Input.wait])

update_binding :: proc() { //TODO: do

}

//... if we really need or want to have many keys -> one action, we can invert the map to be a map of KEYS to ACTIONS
//this isnt too useful by itself as now we face the opposite issue but you can instead map KEYS to a bitset of ACTIONS for a wider range