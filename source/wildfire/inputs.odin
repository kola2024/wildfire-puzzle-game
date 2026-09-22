#+feature dynamic-literals
package fire

import rl "vendor:raylib"

Input :: enum i32 {
	menu_up,
	menu_down,
    menu_select,
	COUNT,
}

Action := [Input.COUNT]rl.KeyboardKey{}

init_bindings :: proc() {
	// for i in Input(0) ..< Input.COUNT {
	// 	Action[Input(i)] = .KEY_NULL
	// }
	Action[Input.menu_up] = .UP
	Action[Input.menu_down] = .DOWN
	Action[Input.menu_select] = .ENTER
}

update_binding :: proc() {

}

//... if we really need or want to have many keys -> one action, we can invert the map to be a map of KEYS to ACTIONS
//this isnt too useful by itself as now we face the opposite issue but you can instead map KEYS to a bitset of ACTIONS for a wider range