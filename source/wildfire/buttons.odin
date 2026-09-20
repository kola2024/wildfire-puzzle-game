package fire

import rl "vendor:raylib"

check_button_active :: proc(w: ^World, button: ^Button) -> bool {
    button.active = rl.CheckCollisionPointRec(w.mouse_game, button.rect)
    return button.active
}

check_button_state :: proc() {

}