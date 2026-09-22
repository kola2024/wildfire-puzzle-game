package fire

import rl "vendor:raylib"
//import "core:fmt"
//import "core:math"
//import "core:math/linalg"
//import "core:math/rand"

RES_W :: 100

draw_world :: proc(w: ^World) {
    //dont rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
    rl.BeginTextureMode(w.game.rentex)
    rl.ClearBackground({20, 20, 20, 255})

    rl.DrawCircle(0, 0, 5, rl.YELLOW)
    for b in w.buttons {
        if !b.active do draw_button(b)
        else do draw_button_a(b)
    }
    rl.EndTextureMode()
    src := rl.Rectangle{0, 0, RES_W, -RES_W}
    dst := rl.Rectangle{w.game.pos.x, w.game.pos.y, w.game.size, w.game.size}
    rl.DrawTexturePro(w.game.rentex.texture, src, dst, {0,0}, 0, rl.WHITE)
    //dont rl.EndDrawing()
}

//temp. in future add color and style whatnot
draw_button :: proc(button: Button) {
    rl.DrawRectangleRec(button.rect, rl.LIME)
    rl.GuiLabel(button.rect, button.label)
}

draw_button_a :: proc(button: Button) {
    rl.DrawRectangleRec(button.rect, rl.GREEN)
    rl.GuiLabel(button.rect, button.label)
}