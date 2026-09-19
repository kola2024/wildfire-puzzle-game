package fire

import rl "vendor:raylib"

check_button_active :: proc(w: ^World, button: ^Button) -> bool {
    //w.game.pos

    new_rect := rl.Rectangle{
        button.rect.x + w.game.pos.x,
        button.rect.y + w.game.pos.y,
        button.rect.width * 100,
        button.rect.height * 100,
    }

    if rl.CheckCollisionPointRec(w.mouse, new_rect) {
        button.active = true
        rl.BeginDrawing()
 rl.DrawRectangleRec(button.rect, rl.YELLOW)
 rl.EndDrawing()
        return true
       
    }
    button.active = false
    return false
}

check_button_state :: proc() {

}