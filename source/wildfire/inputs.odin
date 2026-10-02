package fire

import rl "vendor:raylib"

Input :: enum i32 {
	fullscreen,
	back,

	menu_up,
	menu_down,
    menu_select,

	up,
	down,
	left,
	right,
	wait,
}

max_binds :: 3 //?

action := [Input][max_binds]rl.KeyboardKey{}

init_bindings :: proc() {
	bind(.fullscreen, .F11)
	bind(.menu_up, .W)			; bind(.menu_up, .UP)
	bind(.menu_down, .S)		; bind(.menu_down, .DOWN)
	bind(.menu_select, .ENTER)	; bind(.menu_select, .SPACE)
	bind(.up, .W)				; bind(.up, .UP)
	bind(.down, .S)				; bind(.down, .DOWN)
	bind(.left, .A)				; bind(.left, .LEFT)
	bind(.right, .D)			; bind(.right, .RIGHT)
	bind(.wait, .ENTER)			; bind(.wait, .SPACE)
	bind(.back, .ESCAPE)
	//log233332(action[.wait])
}

bind :: proc{bind_index, bind_null}

bind_index :: proc(input: Input, index: int, key: rl.KeyboardKey) {
	action[input][index] = key
}

bind_null :: proc(input: Input, key: rl.KeyboardKey) {
	for &setkey in action[input] {
		if setkey == .KEY_NULL {
			setkey = key
			return
		}
	}
}

action_pressed :: proc(input: Input) -> bool {
	for key in action[input] {
		if key != .KEY_NULL && rl.IsKeyPressed(key) {
			return true
		}
	}
	return false
}



//accessed via e.g. rl.IsKeyPressed(Action[Input.wait])

update_binding :: proc() { //TODO: do

}