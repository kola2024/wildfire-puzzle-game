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
	}

    if w.game_menu {
        rl.DrawRectanglePro({0, 0, 100, 100}, {0,0}, 0, {0,0,0,150})
        rl.DrawRectanglePro({10, 10, 80, 80}, {0,0}, 0, rl.BEIGE)
    }

    for b in w.buttons {
        if _, ok := b.action.(BA_Nothing) ; ok do draw_button_info(b)
        else if !b.active do draw_button(b)
        else do draw_button_a(b)
    }

    rl.EndMode2D()

    
    //dont rl.EndDrawing()
}

//temp. in future add color and style whatnot
draw_button :: proc(button: Button) {
    rl.DrawRectangleRec(button.rect, rl.RAYWHITE)
    rl.DrawTextEx(rl.GetFontDefault(), button.label, {button.rect.x+1, button.rect.y}, 5, 1, rl.BLACK)
}

draw_button_a :: proc(button: Button) {
    rl.DrawRectangleRec(button.rect, rl.GRAY)
    rl.DrawTextEx(rl.GetFontDefault(), button.label, {button.rect.x+1, button.rect.y}, 5, 1, rl.BLACK)
}

draw_button_info :: proc(button: Button) {
    //rl.DrawRectangleRec(button.rect, rl.RAYWHITE)
    rl.DrawTextEx(rl.GetFontDefault(), button.label, {button.rect.x+1, button.rect.y}, 8, 1, rl.RED)
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
            if tile != .None {
                rl.DrawTexturePro(w.resources.atlas, Object_Recs[tile], dest_rec, {0,0}, 0, rl.WHITE)
            }
        }
    }
    player_dest_rec := rl.Rectangle{f32(offset_x + f32(w.level.player.pos.x) * scale), f32(offset_y + f32(w.level.player.pos.y) * scale), f32(scale), f32(scale)}
    rl.DrawTexturePro(w.resources.atlas, Object_Recs[Object.None], player_dest_rec, {0,0}, 0, rl.RED)
}