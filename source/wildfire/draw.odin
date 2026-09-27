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

    //rl.DrawCircle(0, 0, 5, rl.YELLOW)

    


    for b in w.buttons {
        if !b.active do draw_button(b)
        else do draw_button_a(b)
    }
    rl.EndTextureMode()
    src := rl.Rectangle{0, 0, RES_W, -RES_W}
    dst := rl.Rectangle{w.game.pos.x, w.game.pos.y, w.game.size, w.game.size}
    rl.DrawTexturePro(w.game.rentex.texture, src, dst, {0,0}, 0, rl.WHITE)
    ratio := w.game.size / RES_W
    cam := rl.Camera2D{w.game.pos, {0,0}, 0, ratio}
    //w.game.
    rl.BeginMode2D(cam)
    switch w.state {
	case .main_menu, .level_menu:

	case .game:
		draw_game(w)
	case .game_menu:
	}
    rl.EndMode2D()
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

draw_game :: proc(w: ^World) {
    //rl.DrawCircleV(w.level.player.pos, 4, rl.PURPLE)
    current_level := w.manifest.levels[w.level_index]

    max_dimension := max(current_level.size.x, current_level.size.y)
    scale := (RES_W) / f32(max_dimension)

    offset_x := (RES_W - (scale * f32(current_level.size.x))) / 2
    offset_y := (RES_W - (scale * f32(current_level.size.y))) / 2

    for x in 0..<current_level.size.x {
        for y in 0..<current_level.size.y {
            dest_rec := rl.Rectangle{f32(offset_x + f32(x) * scale), f32(offset_y + f32(y) * scale), f32(scale), f32(scale)}
            tile := w.level.grid[index_from_coords(x, y, current_level.size.x)]
                rl.DrawTexturePro(w.resources.atlas, Object_Recs[tile], dest_rec, {0,0}, 0, rl.WHITE)
        }
    }
    player_dest_rec := rl.Rectangle{f32(offset_x + f32(w.level.player.pos.x) * scale), f32(offset_y + f32(w.level.player.pos.y) * scale), f32(scale), f32(scale)}
    rl.DrawTexturePro(w.resources.atlas, Object_Recs[Object.None], player_dest_rec, {0,0}, 0, rl.RED)
}